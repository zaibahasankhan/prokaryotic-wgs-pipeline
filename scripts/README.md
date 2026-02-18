## 📑 Pipeline Script

The main pipeline script is available in the scripts folder

It automates:

- FastQC
- fastp trimming
- SPAdes assembly
- QUAST, BUSCO
- Prokka annotation
- Abricate AMR detection
- ANI analysis

To run:

chmod +x run_pipeline.sh

./scripts/run_pipeline.sh
