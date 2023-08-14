rule QC_data:
    input:
        lambda wildcards: config['samples'][wildcards.sample]['R1'],
        lambda wildcards: config['samples'][wildcards.sample]['R2']
    output:
        config['project_dir'] + "/result/01.Data/{sample}_R1.fq.gz",
        config['project_dir'] + "/result/01.Data/{sample}_R2.fq.gz"
    shell:
        "ln -sf {input[0]} {output[0]} &&"
        "ln -sf {input[1]} {output[1]}"

rule cutadapt:
    input:
        config['project_dir'] + "/result/01.Data/{sample}_R1.fq.gz",
        config['project_dir'] + "/result/01.Data/{sample}_R2.fq.gz"
    output:
        config['project_dir'] + "/result/01.Data/{sample}_clean_R1.fq.gz",
        config['project_dir'] + "/result/01.Data/{sample}_clean_R2.fq.gz"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/01.data_qc_{sample}.log.o",
        config['project_dir'] + "/result/log/01.data_qc_{sample}.log.e"
    shell:
        "cutadapt --cores 4 -a AGATCGGAAGAG -A AGATCGGAAGAG -q 20 -m 16 -o {output[0]} -p {output[1]} {input[0]} {input[1]} > {log[0]} 2> {log[1]}"

rule raspberry_fastqc:
    input:
        R1 = config['project_dir'] + "/result/01.Data/{sample}_R1.fq.gz",
        R2 = config['project_dir'] + "/result/01.Data/{sample}_R2.fq.gz",
        clean_R1 = config['project_dir'] + "/result/01.Data/{sample}_clean_R1.fq.gz",
        clean_R2 = config['project_dir'] + "/result/01.Data/{sample}_clean_R2.fq.gz"
    output:
        expand([config['project_dir'] + "/result/02.QC/{{sample}}_{reads}_fastqc.html", config['project_dir'] + "/result/02.QC/{{sample}}_qc.txt"],reads=reads,sample=config['samples']),
        R1_stat=config['project_dir'] + "/result/02.QC/{sample}_R1.stat",
        R2_stat=config['project_dir'] + "/result/02.QC/{sample}_R2.stat",
        clean_R1_stat=config['project_dir'] + "/result/02.QC/{sample}_clean_R1.stat",
        clean_R2_stat=config['project_dir'] + "/result/02.QC/{sample}_clean_R2.stat",
    threads:
        4
    params:
        outdir=config['project_dir'] + "/result/02.QC/",
        qc_sample=config['project_dir'] + "/result/02.QC/{sample}"
    log:
        config['project_dir'] + "/result/log/02.fastqc_{sample}.log.o",
        config['project_dir'] + "/result/log/02.fastqc_{sample}.log.e",
        config['project_dir'] + "/result/log/02.fastqc_{sample}_clean.log.o",
        config['project_dir'] + "/result/log/02.fastqc_{sample}_clean.log.e"
    shell:
        "fastqc -o {params.outdir} -t {threads} {input.R1} {input.R2} > {log[0]} 2> {log[1]} &&"
        "fastqc -o {params.outdir} -t {threads} {input.clean_R1} {input.clean_R2} > {log[2]} 2> {log[3]} &&"
        "raspberry {input.R1} > {output.R1_stat} &&"
        "raspberry {input.R2} > {output.R2_stat} &&"
        "raspberry {input.clean_R1} > {output.clean_R1_stat} &&"
        "raspberry {input.clean_R2} > {output.clean_R2_stat} &&"
        "python /home/chenzh/script/python/qc_summary.py {params.qc_sample} {params.qc_sample}_qc.txt"

rule multiqc:
    input:
        expand(config['project_dir'] + "/result/02.QC/{sample}_qc.txt",sample=config['samples'])
    params:
        config['project_dir'] + "/result/02.QC/"
    output:
        config['project_dir'] + "/result/02.QC/multiqc_report.html"
    shell:    
        "multiqc {params} --filename {output}"