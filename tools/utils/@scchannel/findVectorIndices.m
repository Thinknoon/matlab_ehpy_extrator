{
    "name": "ID.LIP_20201103L3.SC_ATAC_GEX_COUNTER_CS.SC_ATAC_GEX_COUNTER._ATAC_MATRIX_COMPUTER._PEAK_CALLER.DETECT_PEAKS.fork0.chnk15",
    "pid": 277413,
    "host": "localhost",
    "type": "local",
    "cwd": "/mnt/usb3/LIP_20201103L3/SC_ATAC_GEX_COUNTER_CS/SC_ATAC_GEX_COUNTER/_ATAC_MATRIX_COMPUTER/_PEAK_CALLER/DETECT_PEAKS/fork0/chnk15-u72b3783d00/files",
    "python": {
        "binpath": "/root/Application/cellranger-arc-2.0.0/external/anaconda/bin/python",
        "version": "3.7.6 (default, Jan  8 2020, 19:59:22) \n[GCC 7.3.0]"
    },
    "rusage": {
        "self": {
            "ru_maxrss": 22704,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 1112,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 0.019146,
            "ru_stime": 0.023564,
            "ru_inblock": 8,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 1
        },
        "children": {
            "ru_maxrss": 1743180,
            "ru_ixrss": 0,
            "ru_idrss": 0,
            "ru_minflt": 821804,
            "ru_majflt": 0,
            "ru_nswap": 0,
            "ru_utime": 184.778968,
            "ru_stime": 5.796536,
            "ru_inblock": 101536,
            "ru_oublock": 0,
            "ru_msgsnd": 0,
            "ru_msgrcv": 0,
            "ru_nsignals": 0,
            "ru_nivcsw": 348
        }
    },
    "used_bytes": {
        "rss": 1770573824,
        "shared": 30138368,
        "vmem": 3086770176,
        "text": 4665344,
        "stack": 2675363840,
        "proc_count": 1
    },
    "io": {
        "total": {
            "read": {
                "sysc": 1336846,
                "bytes": 0
            },
            "write": {
                "sysc": 40564,
                "bytes": 0
            }
        },
        "max": {
            "read": {
                "sysc": 12431.785713925312,
                "bytes": 0
            },
            "write": {
                "sysc": 826.9188078191679,
                "bytes": 0
            }
        },
        "dev": {
            "read": {
                "sysc": 4197.026055006545,
                "bytes": 0
            },
            "write": {
                "sysc": 117.69280601010095,
                "bytes": 0
            }
        }
    },
    "wallclock": {
        "start": "2022-11-19 16:00:37",
        "end": "2022-11-19 16:07:01",
        "duration_seconds": 384.504954552
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
                    "sam