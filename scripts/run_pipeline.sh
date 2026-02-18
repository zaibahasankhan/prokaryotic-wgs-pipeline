#!/bin/bash

# ==========================================
# Prokaryotic WGS Pipeline
# Author: Dr. Zaiba Hasan Khan
# ==========================================

set -e
set -o pipefail

SAMPLE="SRR2584403"
THREADS=8

BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"
RESULTS_DIR="${BASE_DIR}/results"
REF_DIR="${BASE_DIR}/reference"

# ------------------------------------------
# Create directories
# ------------------------------------------

mkdir -p ${DATA_DIR}
mkdir -p ${RESULTS_DIR}/{fastqc,fastp,after_trim_fastqc,spades,quast,busco,prokka,abricate,ani}
mkdir -p ${REF_DIR}

echo "=========================================="
echo "Starting pipeline for ${SAMPLE}"
echo "=========================================="

# ------------------------------------------


# ------------------------------------------
# 1. FastQC (Raw Reads)
# ------------------------------------------

echo "Running FastQC..."
fastqc \
${DATA_DIR}/${SAMPLE}_1.fastq.gz \
${DATA_DIR}/${SAMPLE}_2.fastq.gz \
-o ${RESULTS_DIR}/fastqc \
-t ${THREADS}

# ------------------------------------------
# 2. fastp Trimming
# ------------------------------------------

echo "Running fastp..."
fastp \
-i ${DATA_DIR}/${SAMPLE}_1.fastq.gz \
-I ${DATA_DIR}/${SAMPLE}_2.fastq.gz \
-o ${RESULTS_DIR}/fastp/${SAMPLE}_R1_trimmed.fastq.gz \
-O ${RESULTS_DIR}/fastp/${SAMPLE}_R2_trimmed.fastq.gz \
--detect_adapter_for_pe \
--length_required 50 \
--thread ${THREADS} \
--html ${RESULTS_DIR}/fastp/${SAMPLE}_fastp.html

# ------------------------------------------
# 3. SPAdes Assembly
# ------------------------------------------

echo "Running SPAdes..."
spades.py \
-1 ${RESULTS_DIR}/fastp/${SAMPLE}_R1_trimmed.fastq.gz \
-2 ${RESULTS_DIR}/fastp/${SAMPLE}_R2_trimmed.fastq.gz \
-o ${RESULTS_DIR}/spades \
-t ${THREADS} \
-m 4 \
--isolate

# ------------------------------------------
# 4. QUAST
# ------------------------------------------

echo "Running QUAST..."
quast.py \
${RESULTS_DIR}/spades/contigs.fasta \
-o ${RESULTS_DIR}/quast \
-t ${THREADS}

# ------------------------------------------
# 5. BUSCO
# ------------------------------------------

echo "Running BUSCO..."
busco \
-i ${RESULTS_DIR}/spades/contigs.fasta \
-o busco_output \
-m genome \
-l bacteria_odb10 \
--cpu ${THREADS} \
--out_path ${RESULTS_DIR}/busco \
-f

# ------------------------------------------
# 6. Prokka Annotation
# ------------------------------------------

echo "Running Prokka..."
prokka \
--outdir ${RESULTS_DIR}/prokka \
--prefix ${SAMPLE} \
--cpus ${THREADS} \
${RESULTS_DIR}/spades/contigs.fasta

# ------------------------------------------
# 7. Abricate AMR Detection
# ------------------------------------------

echo "Running Abricate..."
abricate --db resfinder ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/resfinder.txt
abricate --db card ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/card.txt
abricate --db vfdb ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/vfdb.txt
abricate --db ncbi ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/ncbi.txt

# ------------------------------------------
# 8. Download Reference Genome (if needed)
# ------------------------------------------

REF_GENOME="${REF_DIR}/Ecoli_K12.fna"

if [ ! -f ${REF_GENOME} ]; then
    echo "Downloading E. coli reference genome..."
    wget -O ${REF_GENOME} \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/005/845/GCA_000005845.2_ASM584v2/GCA_000005845.2_ASM584v2_genomic.fna
fi

# ------------------------------------------
# 9. ANI Analysis
# ------------------------------------------

echo "Running fastANI..."
fastANI \
-q ${RESULTS_DIR}/spades/contigs.fasta \
-r ${REF_GENOME} \
-o ${RESULTS_DIR}/ani/ani_results.txt

echo "ANI analysis completed"

echo "=========================================="
echo "Pipeline completed successfully for ${SAMPLE}"
echo "=========================================="

