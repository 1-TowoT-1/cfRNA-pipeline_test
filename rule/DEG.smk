rule DEG:
    input:
        config['project_dir'] + "/result/04.EXP/All_sample_count.txt"
    output:
        config['project_dir'] + "/result/05.DEG/{DEG_info}_raw_" + config['DEG_software'] + ".xls"
    params:
        scripts=config['scripts'],
        DEG_software=config['DEG_software'],
        groups_samples_info=';'.join([f'{key}:{value}' for key, value in config['group'].items()]),
        outdir=config['project_dir'] + "/result/05.DEG/"
    shell:
        """
        Rscript {params.scripts}/DEG_analysis.R {params.DEG_software} \
        "{params.groups_samples_info}" \
        {wildcards.DEG_info} \
        {input} \
        {params.outdir}
        """

rule volcano_plot:
    input:
        config['project_dir'] + "/result/05.DEG/{DEG_info}_raw_" + config['DEG_software'] + ".xls"
    output:
        config['project_dir'] + "/result/05.DEG/{DEG_info}_volcano.png"
    params:
        scripts=config['scripts'],
        DEG_software=config['DEG_software'],
        outdir=config['project_dir'] + "/result/05.DEG/"
    shell:
        """
        Rscript {params.scripts}/volcano_summary.R {input} \
        {wildcards.DEG_info} \
        {params.DEG_software} \
        {params.outdir}
        """