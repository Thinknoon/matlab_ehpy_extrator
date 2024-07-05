{
    "name": "ID.LIP_20201103L3.SC_ATAC_GEX_COUNTER_CS.SC_ATAC_GEX_COUNTER._ATAC_MATRIX_COMPUTER._PEAK_CALLER.DETECT_PEAKS.fork0.chnk19",
    "pid": 277760,
    "host": "localhost",
    "type": "local",
    "cwd": "/mnt/usb3/LIP_20201103L3/SC_ATAC_GEX_COUNTER_CS/SC_ATAC_GEX_COUNTER/_ATAC_MATRIX_COMPUTER/_PEAK_CALLER/DETECT_PEAKS/fork0/chnk19-u72b3783d00/files",
    "python": {
        "binpath": "/root/Application/cellranger-arc-2.0.0/external/anaconda/bin/python",
        "version": "3.7.6 (default, Jan  8 2020, 19:59:22) \n[GCC 7.3.0]"
    },
    "rusage": {
        "self": {
            "ru_maxrss": 22704,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1052,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 0.015232,
            "ru_stime": 0.022871,
            "ru_inblock": 8,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 1
        },
        "children": {
            "ru_maxrss": 1396264,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 584731,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 170.015947,
            "ru_stime": 5.208098,
            "ru_inblock": 86584,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 240
        }
    },
    "used_bytes": {
        "rss": 1419927552,
        "shared": 30126080,
        "vmem": 2725548032,
        "text": 4665344,
        "stack": 2314141696,
        "proc_count": 1
    },
    "io": {
        "total": {
            "read": {
                "sysc": 1283622,
                "bytes": 0
            },
            "write": {
                "sysc": 35516,
                "bytes": 0
            }
        },
        "max": {
            "read": {
                "sysc": 12497.515861438374,
                "bytes": 0
            },
            "write": {
                "sysc": 826.2755173297725,
                "bytes": 0
            }
        },
        "dev": {
            "read": {
                "sysc": 4435.41595781691,
                "bytes": 0
            },
            "write": {
                "sysc": 123.42891827795206,
                "bytes": 0
            }
        }
    },
    "wallclock": {
        "start": "2022-11-19 16:01:28",
        "end": "2022-11-19 16:07:09",
        "duration_seconds": 340.734461062
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
          