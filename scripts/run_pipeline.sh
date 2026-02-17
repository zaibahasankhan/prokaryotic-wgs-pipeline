#!/bin/bash

# ==========================================
# Prokaryotic WGS Pipeline
# Author: Dr. Zaiba Hasan Khan
# ==========================================

set -e

SAMPLE="SRR2584403"
THREADS=8

BASE_DIR=$(pwd)
DATA_DIR="${BASE_DIR}/data"
RESULTS_DIR="${BASE_DIR}/results"

mkdir -p ${DATA_DIR}
mkdir -p ${RESULTS_DIR}/{fastqc,fastp,after_trim_fastqc,spades,quast,busco,prokka,abricate,ani}

echo "Starting pipeline for ${SAMPLE}"

# ------------------------------------------
# 1. FastQC (Raw Reads)
# ------------------------------------------

fastqc \
${DATA_DIR}/${SAMPLE}_1.fastq.gz \
${DATA_DIR}/${SAMPLE}_2.fastq.gz \
-o ${RESULTS_DIR}/fastqc \
-t ${THREADS}

# ------------------------------------------
# 2. fastp Trimming
# ------------------------------------------

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

quast.py \
${RESULTS_DIR}/spades/contigs.fasta \
-o ${RESULTS_DIR}/quast \
-t ${THREADS}

# ------------------------------------------
# 5. BUSCO
# ------------------------------------------

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

prokka \
--outdir ${RESULTS_DIR}/prokka \
--prefix ${SAMPLE} \
--cpus ${THREADS} \
${RESULTS_DIR}/spades/contigs.fasta

# ------------------------------------------
# 7. Abricate AMR Detection
# ------------------------------------------

abricate --db resfinder ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/resfinder.txt
abricate --db card ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/card.txt
abricate --db vfdb ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/vfdb.txt
abricate --db ncbi ${RESULTS_DIR}/spades/contigs.fasta > ${RESULTS_DIR}/abricate/ncbi.txt

echo "Pipeline completed successfully for ${SAMPLE}"

