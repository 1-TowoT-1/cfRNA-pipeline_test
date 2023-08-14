rule feature_count:
    input:
        expand(config['project_dir'] + "/result/03.MAP/Genome/{sample}.fix.sort.rdup.bam",sample=config['samples'])
    output:
        config['project_dir'] + "/result/04.EXP/All_sample_featurecount.txt"
    threads:
        2
    params:
        config['genome_path'] + "/" + config['genome_name'] + "_longest_transcipt.gtf"
    shell:
        "featureCounts -p -T {threads} -t exon -a {params} -g gene_id -o {output} {input}"
    
rule feature_summary:
    input:
        config['project_dir'] + "/result/04.EXP/All_sample_featurecount.txt"
    output:
        config['project_dir'] + "/result/04.EXP/All_sample_count.txt",
        config['project_dir'] + "/result/04.EXP/All_sample_FPKM.txt"
    params:
        scripts=config['scripts'],
        outdir=config['project_dir'] + "/result/04.EXP/"
    shell:
        "python {params.scripts}/feature_summary.py {input} All_sample {params.outdir}"

rule Cor_plot:
    input:
        config['project_dir'] + "/result/04.EXP/All_sample_FPKM.txt"
    output:
        config['project_dir'] + "/result/04.EXP/All_sample_Cor.png",
        config['project_dir'] + "/result/04.EXP/All_sample_Cor.pdf"
    params:
        scripts=config['scripts'],
        outdir=config['project_dir'] + "/result/04.EXP/"
    shell:
        "Rscript {params.scripts}/Cor_plot.R {input} {params.outdir}"
    