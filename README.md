# ChIP-seq-analysis-MACS2-
Workflow analysis of MACS for ChIP-seq data

All the analysis are done in Bash language. In addition as can see in the .pptx there are additional analysis using GREAT, UCSC and PSCANChIP.

This is "all in all" the worflow that I used for the project:

(In the repository also find R file related to the creation plots that represent some data)

Download the files and filter them:

**samtools view -bq 1 unfiltered_file.bam > filtered_unique.bam**

Command to watch some characteristic of files:

**Samtools flagstat unfiltered_file.bam**

**Samtools flagstat filtered_file.bam**

Perform the peak calling:

**macs2 callpeak -t IP_mapping.bam -c control_mapping.bam -g hs -n NAME**

Remove the blacklisted regions that we have:

**bedtools intersect -v -a rep2_output_macs2_peaks.narrowPeak  -b ENCFF356LFX.bed.gz > replicate2_no_blacklisted_peaks.narrowPeak
wc -l file_no_blacklisted.narrowPeak**

Observe how many overlaps we have between the two replicates:

**bedtools intersect -a replicate1_no_blacklisted_peaks.narrowPeak -b replicate2_no_blacklisted_peaks.narrowPeak -u | wc -l**

**bedtools intersect -a replicate1_no_blacklisted_peaks.narrowPeak -b merged_no_blacklisted_peaks.narrowPeak -u | wc -l**

This is the calculation of the summit proximity (a way of intersection)

**bedtools closest -a rep1_summits.bed -b rep2_summits.bed -d > closest_output.bed**

**awk '$NF >= 0 && $NF <= 100' closest_output.bed > filtered_output.bed**

Download the gold star file on ENCODE:

**gunzip ENCFF410RJD.bed.gz**

**sort -k1,1 -k2,2n ENCFF410RJD.bed > sorted_ENCODE.bed**

Perform the intersection end remove the blacklisted region:

**bedtools intersect -a rep1_output_macs2_peaks.narrowPeak -b rep2_output_macs2_peaks.narrowPeak -u > intersection_rep1and2_peak.narrowPeak**

**bedtools intersect -v -a intersection_rep1and2_peak.narrowPeak1  -b ENCFF356LFX.bed.gz > intersection_no_blacklisted_peaks.narrowPeak**

Calculate the Jaccard index, permits us to choose the file for the downstream analysis:

**bedtools jaccard -a merged_no_blacklisted_peaks.narrowPeak -b sorted_ENCODE.bed**

In the case of the highest Jaccard index come up for the intersection or we don’t have the related summit file we must create it: 

**awk 'BEGIN {OFS="\t"} {print $1, $2 + $10, $2 + $10 + 1, $4, $9}' intersection_1_2_no_blacklisted_peaks.narrowPeak > intersection_1_2_no_blacklisted_peaks.summits.bed**

Based on the previous choice, of what file we want use for the analysis, we want to see the associated chromatin state

**bedtools intersect -a merged_no_blacklisted_peaks.summit.bed -b K562_ChromHMM_15states.bed -wa -wb > chromatin_states_summit_merged_noBlacklisted.txt**
