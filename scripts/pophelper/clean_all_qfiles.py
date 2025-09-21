# clean_all_qfiles.py

import glob
import os

qfiles = glob.glob("k[0-9].q")
qfiles.sort()

for input_file in qfiles:
    base  = os.path.basename(input_file)
    k_str = base.replace(".q", "")
    k_val = int(k_str.replace("k", ""))
    output_file = f"{k_str}_cleaned.q"

    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            line = line.strip()
            if not line:
                continue
            parts = line.split(":")
            if len(parts) < 2:
                continue
            qvals_str = parts[-1].strip()
            qvals     = qvals_str.split()
            if len(qvals) >= k_val:
                qvals = qvals[-k_val:]
                outfile.write(" ".join(qvals) + "\n")

    print(f"Processed {input_file} -> {output_file}")
