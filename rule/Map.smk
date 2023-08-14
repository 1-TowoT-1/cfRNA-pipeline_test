#这种比对各种数据库，主要是为了分类(因为后续分析只用到了Unique的reads，即一条read比对到一个地方不比对到多个地方)

rule UniVec_map: #接头和引物数据库
    input:
        config['project_dir'] + "/result/01.Data/{sample}_clean_R1.fq.gz",
        config['project_dir'] + "/result/01.Data/{sample}_clean_R2.fq.gz"
    output:
        temp(config['project_dir'] + "/result/03.MAP/UniVec/{sample}.UniVec.sam"),
        config['project_dir'] + "/result/03.MAP/UniVec/{sample}.UniVec.sort.bam",
        temp(config['project_dir'] + "/result/03.MAP/UniVec/{sample}.unmapped.UniVec.1.gz"),
        temp(config['project_dir'] + "/result/03.MAP/UniVec/{sample}.unmapped.UniVec.2.gz")
    params:
        UniVec_index = config['UniVec_index'],
        outdir = config['project_dir'] + "/result/03.MAP/UniVec/",
        unmapped = config['project_dir'] + "/result/03.MAP/UniVec/{sample}.unmapped.UniVec.gz"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.map_UniVec_{sample}.log.o",
        config['project_dir'] + "/result/log/03.map_UniVec_{sample}.log.e"
    shell:
        """
        /home/qizhuo/miniconda3/bin/bowtie2 -x {params.UniVec_index} -1 {input[0]} -2 {input[1]} \
        -p {threads} --norc --sensitive --no-unal --no-mixed --no-discordant \
        --un-conc-gz {params.unmapped} -S {output[0]} >{log[0]} 2> {log[1]} && \
        samtools view --threads {threads} -bS {output[0]} \
        | samtools sort --threads {threads} - -o {output[1]} >>{log[0]} 2>> {log[1]}
        """


rule rRNA_map: #核糖体数据库
    input:
        config['project_dir'] + "/result/03.MAP/UniVec/{sample}.unmapped.UniVec.1.gz",
        config['project_dir'] + "/result/03.MAP/UniVec/{sample}.unmapped.UniVec.2.gz"
    output:
        temp(config['project_dir'] + "/result/03.MAP/rRNA/{sample}.rRNA.sam"),
        config['project_dir'] + "/result/03.MAP/rRNA/{sample}.rRNA.sort.bam",
        temp(config['project_dir'] + "/result/03.MAP/rRNA/{sample}.unmapped.rRNA.1.gz"),
        temp(config['project_dir'] + "/result/03.MAP/rRNA/{sample}.unmapped.rRNA.2.gz"),
    params:
        rRNA_index = config['rRNA_index'],
        unmapped = config['project_dir'] + "/result/03.MAP/rRNA/{sample}.unmapped.rRNA.gz"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.map_rRNA_{sample}.log.o",
        config['project_dir'] + "/result/log/03.map_rRNA_{sample}.log.e"
    shell:
        """
        /home/qizhuo/miniconda3/bin/bowtie2 -x {params.rRNA_index} -1 {input[0]} -2 {input[1]} \
        -p {threads} --norc --sensitive --no-unal --no-mixed --no-discordant \
        --un-conc-gz {params.unmapped} -S {output[0]} >{log[0]} 2> {log[1]} && \
        samtools view --threads {threads} -bS {output[0]} \
        | samtools sort --threads {threads} - -o {output[1]} >>{log[0]} 2>> {log[1]}
        """


rule miRNA_map: #miRNA数据库
    input:
        config['project_dir'] + "/result/03.MAP/rRNA/{sample}.unmapped.rRNA.1.gz",
        config['project_dir'] + "/result/03.MAP/rRNA/{sample}.unmapped.rRNA.2.gz"
    output:
        temp(config['project_dir'] + "/result/03.MAP/miRNA/{sample}.miRNA.sam"),
        config['project_dir'] + "/result/03.MAP/miRNA/{sample}.miRNA.sort.bam",
        temp(config['project_dir'] + "/result/03.MAP/miRNA/{sample}.unmapped.miRNA.1.gz"),
        temp(config['project_dir'] + "/result/03.MAP/miRNA/{sample}.unmapped.miRNA.2.gz"),
    params:
        miRNA_index = config['miRNA_index'],
        unmapped = config['project_dir'] + "/result/03.MAP/miRNA/{sample}.unmapped.miRNA.gz"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.map_miRNA_{sample}.log.o",
        config['project_dir'] + "/result/log/03.map_miRNA_{sample}.log.e"
    shell:
        """
        /home/qizhuo/miniconda3/bin/bowtie2 -x {params.miRNA_index} -1 {input[0]} -2 {input[1]} \
        -p {threads} --norc --sensitive --no-unal --no-mixed --no-discordant \
        --un-conc-gz {params.unmapped} -S {output[0]} >{log[0]} 2> {log[1]} && \
        samtools view --threads {threads} -bS {output[0]} \
        | samtools sort --threads {threads} - -o {output[1]} >>{log[0]} 2>> {log[1]}
        """

rule piRNA_map:
    input:
        config['project_dir'] + "/result/03.MAP/miRNA/{sample}.unmapped.miRNA.1.gz",
        config['project_dir'] + "/result/03.MAP/miRNA/{sample}.unmapped.miRNA.2.gz"
    output:
        temp(config['project_dir'] + "/result/03.MAP/piRNA/{sample}.piRNA.sam"),
        config['project_dir'] + "/result/03.MAP/piRNA/{sample}.piRNA.sort.bam",
        temp(config['project_dir'] + "/result/03.MAP/piRNA/{sample}.unmapped.piRNA.1.gz"),
        temp(config['project_dir'] + "/result/03.MAP/piRNA/{sample}.unmapped.piRNA.2.gz")
    params:
        piRNA_index = config['piRNA_index'],
        unmapped = config['project_dir'] + "/result/03.MAP/piRNA/{sample}.unmapped.piRNA.gz"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.map_piRNA_{sample}.log.o",
        config['project_dir'] + "/result/log/03.map_piRNA_{sample}.log.e"
    shell:
        """
        /home/qizhuo/miniconda3/bin/bowtie2 -x {params.piRNA_index} -1 {input[0]} -2 {input[1]} \
        -p {threads} --norc --sensitive --no-unal --no-mixed --no-discordant \
        --un-conc-gz {params.unmapped} -S {output[0]} >{log[0]} 2> {log[1]} && \
        samtools view --threads {threads} -bS {output[0]} \
        | samtools sort --threads {threads} - -o {output[1]} >>{log[0]} 2>> {log[1]}
        """


rule tRNA_map:
    input:
        config['project_dir'] + "/result/03.MAP/piRNA/{sample}.unmapped.piRNA.1.gz",
        config['project_dir'] + "/result/03.MAP/piRNA/{sample}.unmapped.piRNA.2.gz"
    output:
        temp(config['project_dir'] + "/result/03.MAP/tRNA/{sample}.tRNA.sam"),
        config['project_dir'] + "/result/03.MAP/tRNA/{sample}.tRNA.sort.bam",
        temp(config['project_dir'] + "/result/03.MAP/tRNA/{sample}.unmapped.tRNA.1.gz"),
        temp(config['project_dir'] + "/result/03.MAP/tRNA/{sample}.unmapped.tRNA.2.gz"),
    params:
        tRNA_index = config['tRNA_index'],
        unmapped = config['project_dir'] + "/result/03.MAP/tRNA/{sample}.unmapped.tRNA.gz"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.map_tRNA_{sample}.log.o",
        config['project_dir'] + "/result/log/03.map_tRNA_{sample}.log.e"
    shell:
        """
        /home/qizhuo/miniconda3/bin/bowtie2 -x {params.tRNA_index} -1 {input[0]} -2 {input[1]} \
        -p {threads} --norc --sensitive --no-unal --no-mixed --no-discordant \
        --un-conc-gz {params.unmapped} -S {output[0]} >{log[0]} 2> {log[1]} && \
        samtools view --threads {threads} -bS {output[0]} \
        | samtools sort --threads {threads} - -o {output[1]} >>{log[0]} 2>> {log[1]}
        """  

rule genome_map:
    input:
        config['project_dir'] + "/result/03.MAP/tRNA/{sample}.unmapped.tRNA.1.gz",
        config['project_dir'] + "/result/03.MAP/tRNA/{sample}.unmapped.tRNA.2.gz"
    output:
        config['project_dir'] + "/result/03.MAP/Genome/{sample}_Aligned.out.bam",
        temp(config['project_dir'] + "/result/03.MAP/Genome/{sample}_Log.out"),
        temp(config['project_dir'] + "/result/03.MAP/Genome/{sample}_Log.progress.out"),
        temp(config['project_dir'] + "/result/03.MAP/Genome/{sample}_SJ.out.tab"),
    params:
        index=config['project_dir'] + "/result/03.MAP/Genome/{sample}_",
        genome_path=config['genome_path']
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.map_genome_{sample}.o",
        config['project_dir'] + "/result/log/03.map_genome_{sample}.e"
    shell:
        """
        STAR --genomeDir {params.genome_path} --readFilesIn {input[0]} {input[1]} \
        --runThreadN {threads} --outFileNamePrefix {params.index} --outSAMtype BAM Unsorted \
        --readFilesCommand gzip -d -c --outFilterMultimapNmax 1 > {log[0]} 2> {log[1]}
        """

rule final_bam_del:
    input:
        config['project_dir'] + "/result/03.MAP/Genome/{sample}_Aligned.out.bam"
    output:
        config['project_dir'] + "/result/03.MAP/Genome/{sample}.fix.sort.rdup.bam",
        temp(config['project_dir'] + "/result/03.MAP/Genome/{sample}.fix.bam"),
        temp(config['project_dir'] + "/result/03.MAP/Genome/{sample}.fix.sort.bam")
    params:
        config['project_dir'] + "/result/03.MAP/Genome/{sample}"
    threads:
        4
    log:
        config['project_dir'] + "/result/log/03.bam_del_{sample}.o",
        config['project_dir'] + "/result/log/03.bam_del_{sample}.e"
    shell:
        """
        samtools fixmate -m -c {input[0]} {params}.fix.bam > {log[0]} 2> {log[1]} &&
        samtools sort --threads {threads} {params}.fix.bam -o {params}.fix.sort.bam >> {log[0]} 2>> {log[1]} &&
        samtools markdup -r {params}.fix.sort.bam {params}.fix.sort.rdup.bam >> {log[0]} 2>> {log[1]} &&
        samtools index {params}.fix.sort.rdup.bam >> {log[0]} 2>> {log[1]}
        """

rule fragment_plot:
    input:
        config['project_dir'] + "/result/03.MAP/Genome/{sample}.fix.sort.rdup.bam"
    output:
        config['project_dir'] + "/result/04.EXP/{sample}_fragment.txt"
    params:
        scripts=config['scripts'],
        outdir=config['project_dir'] + "/result/04.EXP/"
    shell:
        """
        samtools view {input} |awk -F '\\t' 'function abs(x){{return ((x < 0.0) ? -x : x)}}{{print $1"\\t"abs($9)}}' | sort | uniq | cut -f2 > {output} &&
        Rscript {params.scripts}/fragment_plot.R {output} {wildcards.sample} {params.outdir}
        """