

pkgs <- c("sf","readr","dplyr","ggplot2","gstat","sp","raster",
          "rnaturalearth","rnaturalearthdata","ggrepel","RColorBrewer",
          "ggspatial","janitor","Cairo")
to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if(length(to_install)) install.packages(to_install, dependencies = TRUE)

library(sf)
library(readr)
library(dplyr)
library(ggplot2)
library(gstat)
library(sp)
library(raster)
library(rnaturalearth)
library(ggrepel)
library(RColorBrewer)
library(ggspatial)
library(janitor)
library(Cairo)   

# ---- Input ----
setwd("xyz")
infile <- "xyz.csv"

# Read&clean
dat <- readr::read_csv(infile, show_col_types = FALSE) %>%
  janitor::clean_names() %>%
  dplyr::mutate(
    type = tolower(trimws(type)),
    latitude  = as.numeric(gsub(",", ".", as.character(latitude))),
    longitude = as.numeric(gsub(",", ".", as.character(longitude))),
    site_number = suppressWarnings(as.integer(site_number)),
    allelic_richness = as.numeric(allelic_richness),
    private_allelic_richness = as.numeric(private_allelic_richness)
  )

# Drop bad coords
dat_ok <- dat %>% dplyr::filter(!is.na(latitude) & !is.na(longitude))

#Basemap&projection
world <- rnaturalearth::ne_countries(scale = 50, returnclass = "sf")
crs_proj <- 3035  # Europe LAEA (meters)

# Functions
prep_layers <- function(dat_in, buf_km = 250) {
  pts <- sf::st_as_sf(dat_in, coords = c("longitude","latitude"), crs = 4326, remove = FALSE)
  world_p <- sf::st_transform(world, crs_proj)
  pts_p   <- sf::st_transform(pts, crs_proj)
  
  bb <- sf::st_bbox(pts_p)
  buf_m <- buf_km * 1000
  bb2 <- bb
  bb2["xmin"] <- bb["xmin"] - buf_m
  bb2["xmax"] <- bb["xmax"] + buf_m
  bb2["ymin"] <- bb["ymin"] - buf_m
  bb2["ymax"] <- bb["ymax"] + buf_m
  bb_poly <- sf::st_as_sfc(bb2)
  
  world_crop <- sf::st_intersection(world_p, bb_poly)
  land_union <- sf::st_union(world_crop)
  land_sp <- as(land_union, "Spatial")
  
  list(pts_p = pts_p, world_crop = world_crop, land_sp = land_sp, bb2 = bb2)
}

make_country_labels <- function(world_crop,
                                label_field = c("iso_a2","name_long"),
                                top_n = 25) {
  label_field <- match.arg(label_field)
  wc <- world_crop %>%
    dplyr::mutate(
      area = as.numeric(sf::st_area(.)),
      lab  = .data[[label_field]]
    ) %>%
    dplyr::filter(!is.na(lab), lab != "-99", lab != "") %>%
    dplyr::arrange(dplyr::desc(area)) %>%
    dplyr::slice_head(n = top_n) %>%
    dplyr::mutate(geom_pt = sf::st_point_on_surface(geometry)) %>%
    sf::st_as_sf()
  
  sf::st_geometry(wc) <- wc$geom_pt
  wc$geom_pt <- NULL
  wc
}

make_idw_raster <- function(pts_sf_proj, varname, res_km = 25, idp = 2.0, nmax = 12) {
  pts_use <- pts_sf_proj %>% dplyr::filter(!is.na(.data[[varname]]))
  pts_sp  <- as(pts_use, "Spatial")
  
  bb <- sf::st_bbox(pts_sf_proj)
  r_template <- raster::raster(
    xmn = bb["xmin"], xmx = bb["xmax"],
    ymn = bb["ymin"], ymx = bb["ymax"],
    res = res_km * 1000,
    crs = sp::proj4string(pts_sp)
  )
  grd <- as(r_template, "SpatialPixels")
  fml <- as.formula(paste0(varname, " ~ 1"))
  
  idw_out <- gstat::idw(fml, locations = pts_sp, newdata = grd, idp = idp, nmax = nmax)
  raster::raster(idw_out, layer = 1)
}

plot_interp_map <- function(dat_in,
                            varname,
                            out_pdf,
                            res_km = 25,
                            palette,
                            mask_to_land = TRUE,
                            label_sites = TRUE,
                            label_col = "site_number",
                            drop_site_number = NULL,
                            country_labels = TRUE,
                            country_label_field = c("iso_a2","name_long"),
                            country_top_n = 25,
                            width_in = 10,
                            height_in = 6) {
  
  if (!is.null(drop_site_number)) {
    dat_in <- dat_in %>% dplyr::filter(.data$site_number != drop_site_number)
  }
  
  L <- prep_layers(dat_in, buf_km = 250)
  pts_p <- L$pts_p
  world_crop <- L$world_crop
  land_sp <- L$land_sp
  bb2 <- L$bb2
  
  r <- make_idw_raster(pts_p, varname, res_km = res_km)
  if (mask_to_land) r <- raster::mask(r, land_sp)
  
  df_r <- as.data.frame(r, xy = TRUE, na.rm = TRUE)
  names(df_r)[3] <- "z"
  
  coords <- sf::st_coordinates(pts_p)
  pts_df <- pts_p %>% sf::st_drop_geometry() %>%
    dplyr::mutate(X = coords[,1], Y = coords[,2])
  
  clab <- NULL
  if (country_labels) {
    clab <- make_country_labels(world_crop,
                                label_field = match.arg(country_label_field),
                                top_n = country_top_n)
    cxy <- sf::st_coordinates(clab)
    clab <- clab %>% sf::st_drop_geometry() %>%
      dplyr::mutate(X = cxy[,1], Y = cxy[,2])
  }
  
  shape_map <- c(sp = 21, cv = 24)
  
  p <- ggplot() +
    geom_raster(data = df_r, aes(x = x, y = y, fill = z)) +
    geom_sf(data = world_crop, fill = NA, color = "grey25", linewidth = 0.25) +
    { if (country_labels)
      geom_text(data = clab, aes(x = X, y = Y, label = lab),
                size = 3.2, color = "grey15", fontface = "bold")
    } +
    geom_point(data = pts_df, aes(x = X, y = Y, shape = type),
               size = 2.6, stroke = 0.6, color = "black", fill = "black") +
    scale_shape_manual(values = shape_map, breaks = c("cv","sp"), name = "type") +
    { if (label_sites)
      ggrepel::geom_text_repel(
        data = pts_df,
        aes(x = X, y = Y, label = .data[[label_col]]),
        size = 3,
        min.segment.length = 0,
        box.padding = 0.2,
        point.padding = 0.15,
        max.overlaps = Inf
      )
    } +
    
    scale_fill_gradientn(colours = palette, name = varname) +
    coord_sf(crs = sf::st_crs(crs_proj),
             xlim = c(bb2["xmin"], bb2["xmax"]),
             ylim = c(bb2["ymin"], bb2["ymax"]),
             expand = FALSE) +
    ggspatial::annotation_scale(location = "br", width_hint = 0.25) +
    labs(x = NULL, y = NULL) +
    theme_minimal(base_size = 12) +
    theme(panel.grid = element_blank())
  
  ggsave(filename = out_pdf,
         plot = p,
         device = grDevices::cairo_pdf,
         width = width_in,
         height = height_in,
         units = "in",
         dpi = 600,
         bg = "white")
  
  p
}


pal_CW <- rev(RColorBrewer::brewer.pal(11, "RdYlBu"))  # blue(low) -> red(high)

pal_AR  <- pal_CW
pal_PAR <- pal_CW


plot_interp_map(dat_ok, "allelic_richness",
                out_pdf = "map_allelic_richness.pdf",
                palette = pal_AR,
                country_label_field = "iso_a2")

plot_interp_map(dat_ok, "private_allelic_richness",
                out_pdf = "map_private_allelic_richness.pdf",
                palette = pal_PAR,
                country_label_field = "iso_a2")

plot_interp_map(dat_ok, "allelic_richness",
                out_pdf = "map_allelic_richness_no_ku.pdf",
                palette = pal_AR,
                drop_site_number = 1,
                country_label_field = "iso_a2")

plot_interp_map(dat_ok, "private_allelic_richness",
                out_pdf = "map_private_allelic_richness_no_ku.pdf",
                palette = pal_PAR,
                drop_site_number = 1,
                country_label_field = "iso_a2")