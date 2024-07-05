{
    "name": "ID.LIP_20201103L3.SC_ATAC_GEX_COUNTER_CS.SC_ATAC_GEX_COUNTER._ATAC_MATRIX_COMPUTER._PEAK_CALLER.DETECT_PEAKS.fork0",
    "pid": 278510,
    "host": "localhost",
    "type": "local",
    "cwd": "/mnt/usb3/LIP_20201103L3/SC_ATAC_GEX_COUNTER_CS/SC_ATAC_GEX_COUNTER/_ATAC_MATRIX_COMPUTER/_PEAK_CALLER/DETECT_PEAKS/fork0/join-u72b3783b6d/files",
    "python": {
        "binpath": "/root/Application/cellranger-arc-2.0.0/external/anaconda/bin/python",
        "version": "3.7.6 (default, Jan  8 2020, 19:59:22) \n[GCC 7.3.0]"
    },
    "rusage": {
        "self": {
            "ru_maxrss": 22704,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 661,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 0.004028,
            "ru_stime": 0.00954,
            "ru_inblock": 0,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 1
        },
        "children": {
            "ru_maxrss": 90736,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 107323,
            "ru_majflt": 7,
            "ru_nswap": 0,
            "ru_utime": 2.404271,
            "ru_stime": 0.77438,
            "ru_inblock": 688,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 56
        }
    },
    "used_bytes": {
        "rss": 101318656,
        "shared": 29245440,
        "vmem": 1363427328,
        "text": 4665344,
        "stack": 952020992,
        "proc_count": 1
    },
    "io": {
        "total": {
            "read": {
                "sysc": 5900,
                "bytes": 0
            },
            "write": {
                "sysc": 6785,
                "bytes": 0
            }
        },
        "max": {
            "read": {
                "sysc": 1177.7549151716557,
                "bytes": 0
            },
            "write": {
                "sysc": 1355.7969289853554,
                "bytes": 0
            }
        },
        "dev": {
            "read": {
                "sysc": 158.7633092654182,
                "bytes": 0
            },
            "write": {
                "sysc": 192.1089801663821,
                "bytes": 0
            }
        }
    },
    "wallclock": {
        "start": "2022-11-19 16:10:42",
        "end": "2022-11-19 16:10:48",
        "duration_seconds": 5.609375275
    },
    "threads": 1,
    "memGB": 5,
    "vmemGB": 8,
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
            "skip_compatibility_check