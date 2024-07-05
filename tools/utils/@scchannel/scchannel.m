{
    "name": "ID.LIP_20201103L3.SC_ATAC_GEX_COUNTER_CS.SC_ATAC_GEX_COUNTER._ATAC_MATRIX_COMPUTER._PEAK_CALLER.DETECT_PEAKS.fork0.chnk13",
    "pid": 277339,
    "host": "localhost",
    "type": "local",
    "cwd": "/mnt/usb3/LIP_20201103L3/SC_ATAC_GEX_COUNTER_CS/SC_ATAC_GEX_COUNTER/_ATAC_MATRIX_COMPUTER/_PEAK_CALLER/DETECT_PEAKS/fork0/chnk13-u72b3783d00/files",
    "python": {
        "binpath": "/root/Application/cellranger-arc-2.0.0/external/anaconda/bin/python",
        "version": "3.7.6 (default, Jan  8 2020, 19:59:22) \n[GCC 7.3.0]"
    },
    "rusage": {
        "self": {
            "ru_maxrss": 22704,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1063,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 0.021205,
            "ru_stime": 0.027129,
            "ru_inblock": 8,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 1
        },
        "children": {
            "ru_maxrss": 2056636,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1212662,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 230.239359,
            "ru_stime": 7.443433,
            "ru_inblock": 158952,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 424
        }
    },
    "used_bytes": {
        "rss": 2091765760,
        "shared": 30109696,
        "vmem": 3393462272,
        "text": 4665344,
        "stack": 2982055936,
        "proc_count": 1
    },
    "io": {
        "total": {
            "read": {
                "sysc": 1495276,
                "bytes": 0
            },
            "write": {
                "sysc": 60629,
                "bytes": 0
            }
        },
        "max": {
            "read": {
                "sysc": 12479.73397051028,
                "bytes": 0
            },
            "write": {
                "sysc": 826.2616279866346,
                "bytes": 0
            }
        },
        "dev": {
            "read": {
                "sysc": 3753.832727899081,
                "bytes": 0
            },
            "write": {
                "sysc": 114.14977344247205,
                "bytes": 0
            }
        }
    },
    "wallclock": {
        "start": "2022-11-19 16:00:21",
        "end": "2022-11-19 16:09:06",
        "duration_seconds": 525.187489541
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
       