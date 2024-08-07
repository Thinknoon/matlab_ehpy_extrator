{
    "name": "ID.LIP_20201103L3.SC_ATAC_GEX_COUNTER_CS.SC_ATAC_GEX_COUNTER._ATAC_MATRIX_COMPUTER._PEAK_CALLER.DETECT_PEAKS.fork0",
    "pid": 253060,
    "host": "localhost",
    "type": "local",
    "cwd": "/mnt/usb3/LIP_20201103L3/SC_ATAC_GEX_COUNTER_CS/SC_ATAC_GEX_COUNTER/_ATAC_MATRIX_COMPUTER/_PEAK_CALLER/DETECT_PEAKS/fork0/split-u72b3783b6d/files",
    "python": {
        "binpath": "/root/Application/cellranger-arc-2.0.0/external/anaconda/bin/python",
        "version": "3.7.6 (default, Jan  8 2020, 19:59:22) \n[GCC 7.3.0]"
    },
    "rusage": {
        "self": {
            "ru_maxrss": 22704,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1117,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 0.012417,
            "ru_stime": 0.028221,
            "ru_inblock": 0,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 1
        },
        "children": {
            "ru_maxrss": 122328,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 155710945,
            "ru_majflt": 154,
            "ru_nswap": 0,
            "ru_utime": 196.76622,
            "ru_stime": 200.704346,
            "ru_inblock": 61328,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 571
        }
    },
    "used_bytes": {
        "rss": 114962432,
        "shared": 29802496,
        "vmem": 1389953024,
        "text": 4665344,
        "stack": 978546688,
        "proc_count": 1
    },
    "io": {
        "total": {
            "read": {
                "sysc": 3250,
                "bytes": 0
            },
            "write": {
                "sysc": 4139,
                "bytes": 0
            }
        },
        "max": {
            "read": {
                "sysc": 648.2400280939236,
                "bytes": 0
            },
            "write": {
                "sysc": 826.6858804637983,
                "bytes": 0
            }
        },
        "dev": {
            "read": {
                "sysc": 72.4637706048729,
                "bytes": 0
            },
            "write": {
                "sysc": 92.40512677127164,
                "bytes": 0
            }
        }
    },
    "wallclock": {
        "start": "2022-11-19 10:11:57",
        "end": "2022-11-19 10:18:37",
        "duration_seconds": 399.917081532
    },
    "threads": 1,
    "memGB": 6,
    "vmemGB": 9,
    "profile_mode": "disable",
    "stackvars_flag": "disable",
    "monitor_flag": "disable",
    "invocation": {
        "call": "SC_ATAC_GEX_COUNTER_CS",
        "args": {
            "custom_peaks": null,
            "feature_linkage_max_dist_mb": null,
            "force_cells": null,
            "k_means_max_clusters": null,
            "no_bam": false,
            "peak_qval": null,
            "reference_path": "/home/home2/mHuang/Macaca_fascicu_5",
            "rna_include_introns": true,
            "sample_def": [
                {
                    "fastq_id": null,
                    "fastq_mode": "ILMN_BCL2FASTQ",
                    "gem_group": null,
                    "lanes": null,
                    "library_type": "Gene Expression",
                    "read_path": "/mnt/usb2/LIP/10x_nuclei_data/LIP_20201103L3/LIP_20201103L3_RNA/Rawdata/L3_RNA",
                    "sample_indices": [
                        "any"
                    ],
                    "sample_names": [
                        "L3_RNA-1"
                    ],
                    "subsample_rate": null,
                    "target_set": null,
                    "target_set_name": null
                },
                {
                    "fastq_id": null,
                    "fastq_mode": "ILMN_BCL2FASTQ",
                    "gem_group": null,
                    "lanes": null,
                    "library_type": "Gene Expression",
                    "read_path": "/mnt/usb2/LIP/10x_nuclei_data/LIP_20201103L3/LIP_20201103L3_RNA_2/Rawdata/L3_RNA",
                    "sample_indices": [
                        "any"
                    ],
                    "sample_names": [
                        "L3_RNA-1"
                    ],
                    "subsample_rate": null,
                    "target_set": null,
                    "target_set_name": null
                },
                {
                    "fastq_id": null,
                    "fastq_mode": "ILMN_BCL2FASTQ",
                    "gem_group": null,
                    "lanes": null,
                    "library_type": "Chromatin Accessibility",
                    "read_path": "/mnt/usb2/LIP/10x_nuclei_data/LIP_20201103L3/LIP_20201103L3_ATAC/Rawdata/L3_ATAC",
                    "sample_indices": [
                        "any"
                    ],
                    "sample_names": [
                        "L3_ATAC-1"
                    ],
                    "subsample_rate": null,
                    "target_set": null,
                    "target_set_name": null
                }
            ],
            "sample_desc": "LIP_20201103L3",
            "sample_id": "LIP_20201103L3",
            "skip_compatibility_check": false
        },
        "mro_file": "atac_rna/sc_atac_gex_counter_cs.mro"
    },
    "version": {
        "martian": "v4.0.5",
        "pipelines": "cellranger-arc-2.0.0"
    }
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          