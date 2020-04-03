# Overview
In ECX 4.2, you can extend mirror disk data partition size dynamically without stopping application.

This guide shows how to extend mirror disk data partition size dynamically

## Note

On Linux, the data partition should be LVM, and its filesystem should be xfs.

On Windows, there is no limitation.

## How to extend mirror disk data partition size

1. On standby server, execute **clpmdctrl --resize** command
    - On Linux
    ```
    > clpmdctrl --resize [the new size of data paritition] [md resource name]

    e.g.
    > clpmdctrl --resize 5G md1
    ```

    - On Windows
    ```
    > clpmdctrl --resize [md resource name] [the new size of data paritition]

    e.g.
    > clpmdctrl --resize md1 5G
    ```

    Tips for specifying disk size
    - K (Kibi byte)
    - M (Mibi byte)
    - G (Gibi byte)
    - T (Tebi byte)

2. On active server, execute **clpmdctrl --resize** command

    Pleaes execute the same command as Step 1

3. On active server, extend the filesystem of the data partition
    - On Linux
        1. Extend the filesystem
            ```
            xfs_growfs [mount point of mirror disk]

            e.g.
            xfs_growfs /mnt/md1
            ```

    - On Windows
        1. Open **Command Prompt**
        2. Open **diskpart**
            ```
            > diskpart
            ```
        3. Confirm the volume number of the data partition
            ```
            e.g.
            DISKPART> list volume

            Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
            ----------  ---  -----------  -----  ----------  -------  ---------  --------
            Volume 0     D   SSS_X64FRE_  UDF    DVD-ROM     4618 MB  Healthy
            Volume 1         System Rese  NTFS   Partition    549 MB  Healthy    System
            Volume 2     C                NTFS   Partition     39 GB  Healthy    Boot
            Volume 3     E                RAW    Partition   1024 MB  Healthy
            Volume 4     F   New Volume   NTFS   Partition   5000 MB  Healthy
            ```
        4. Select the volume number of the data partition
            ```
            DISKPART> select volume [the volume number]

            e.g.
            DISKPART> select volume 4
            ```
        5. Extend the filesystem
            ```
            DISKPART> extend filesystem
            ```
        6. Exit **diskpart**
            ```
            DISKPART> exit
            ```