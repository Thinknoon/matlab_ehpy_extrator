{
    "name": "ID.LIP_20201103L3.SC_ATAC_GEX_COUNTER_CS.SC_ATAC_GEX_COUNTER._ATAC_MATRIX_COMPUTER._PEAK_CALLER.DETECT_PEAKS.fork0.chnk16",
    "pid": 277577,
    "host": "localhost",
    "type": "local",
    "cwd": "/mnt/usb3/LIP_20201103L3/SC_ATAC_GEX_COUNTER_CS/SC_ATAC_GEX_COUNTER/_ATAC_MATRIX_COMPUTER/_PEAK_CALLER/DETECT_PEAKS/fork0/chnk16-u72b3783d00/files",
    "python": {
        "binpath": "/root/Application/cellranger-arc-2.0.0/external/anaconda/bin/python",
        "version": "3.7.6 (default, Jan  8 2020, 19:59:22) \n[GCC 7.3.0]"
    },
    "rusage": {
        "self": {
            "ru_maxrss": 22704,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1064,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 0.021206,
            "ru_stime": 0.02732,
            "ru_inblock": 8,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 2
        },
        "children": {
            "ru_maxrss": 1797384,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1074142,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 244.793284,
            "ru_stime": 7.314549,
            "ru_inblock": 176608,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 375
        }
    },
    "used_bytes": {
        "rss": 1832861696,
        "shared": 30052352,
        "vmem": 3143524352,
        "text": 4665344,
        "stack": 2732118016,
        "proc_count": 1
    },
    "io": {
        "total": {
            "read": {
                "sysc": 1516776,
                "bytes": 0
            },
            "write": {
                "sysc": 68501,
                "bytes": 0
            }
        },
        "max": {
            "read": {
                "sysc": 12394.884089724417,
                "bytes": 0
            },
            "write": {
                "sysc": 826.3799895713603,
                "bytes": 0
            }
        },
        "dev": {
            "read": {
                "sysc": 3622.619686118805,
                "bytes": 0
            },
            "write": {
                "sysc": 118.3221204097827,
                "bytes": 0
            }
        }
    },
    "wallclock": {
        "start": "2022-11-19 16:01:10",
        "end": "2022-11-19 16:10:34",
        "duration_seconds": 563.726689194
    },
    "threads": 1,
    "memGB": 8,
    "vmemGB": 11,
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
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 