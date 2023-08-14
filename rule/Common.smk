reads=["R1","R2","clean_R1","clean_R2"]
output=config['project_dir'] + "/result"

def get_final_output():
    final_output=[]
    if config['QC']:
        final_output=expand([output + "/01.Data/{sample}_{reads}.fq.gz", output + "/02.QC/{sample}_{reads}{ext}"],ext=["_fastqc.html",".stat"],sample=config['samples'],reads=reads)
        final_output.extend(expand([output + "/02.QC/{sample}_qc.txt"],sample=config['samples']))
        final_output.append(output + "/02.QC/multiqc_report.html")
    if config['MAP']:
        final_output.extend(expand([output + "/03.MAP/{database}/{sample}.{database}.sort.bam"],sample=config['samples'],database=['UniVec','rRNA','miRNA','piRNA','tRNA']))
        final_output.extend(expand(output + "/03.MAP/Genome/{sample}{ext2}",sample=config['samples'],ext2=['_Aligned.out.bam','.fix.sort.rdup.bam']))
        final_output.extend(expand(output + "/04.EXP/{sample}_fragment.txt",sample=config['samples']))
    if config['Count']:
        final_output.extend(expand(output + "/04.EXP/All_sample_{ext3}.txt",ext3=["featurecount","count","FPKM"]))
        final_output.extend(expand(output + "/04.EXP/All_sample_{ext4}",ext4=["Cor.png","Cor.pdf"]))
    if config['DEG']:
        final_output.extend(expand(output + "/05.DEG/{DEG_info}_raw_" + config['DEG_software'] + ".xls",DEG_info=config['DEG_info']))
        final_output.extend(expand(output + "/05.DEG/{DEG_info}_volcano.png",DEG_info=config['DEG_info']))
    return final_output