import pandas as pd

file_path = '/Users/sanzhar/Desktop/adze_8_pop_input.xlsx'
df = pd.read_excel(file_path)
df.head()

allele_columns_a1 = [col for col in df.columns if col.endswith('_A1')]
allele_columns_a2 = [col.replace('_A1', '_A2') for col in allele_columns_a1]
base_columns = ['sorted_sample_id', 'cluster']

transformed_data = pd.DataFrame()

for index, row in df.iterrows():
    a1_row = row[base_columns + allele_columns_a1].copy()
    a1_row.index = base_columns + [col.replace('_A1', '') for col in allele_columns_a1]

    a2_row = row[base_columns + allele_columns_a2].copy()
    a2_row.index = base_columns + [col.replace('_A2', '') for col in allele_columns_a2]

    transformed_data = pd.concat([transformed_data, a1_row.to_frame().T, a2_row.to_frame().T])

transformed_data.reset_index(drop=True, inplace=True)

output_file_path = '/Users/sanzhar/Desktop/script_transformed_adze_input_8_pop.xlsx'
transformed_data.to_excel(output_file_path, index=False)

output_file_path
