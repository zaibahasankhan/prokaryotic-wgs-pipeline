## 📑 Pipeline Script

The main pipeline script is available at:

It automates:

- FastQC
- fastp trimming
- SPAdes assembly
- QUAST, BUSCO
- Prokka annotation
- Abricate AMR detection
- ANI analysis

Make sure to describe usage:

```bash
./scripts/run_pipeline.sh
