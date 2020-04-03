import sys
import glob
import numpy as np
import pandas as pd
import matplotlib as mpl
from matplotlib import pyplot as plt
mpl.rcParams['figure.figsize'] = (12,6)
import seaborn as sns
sns.set(font_scale=1.5, context="paper", style="white", font="serif")
pal = sns.color_palette()
cols = pal.as_hex()

def main():

    systems = ['cosma7','tesseract']
    systems = ['cosma7','tesseract']
    sysdetails = {}
    
    tempd = {}
    tempd['dir'] = '../results/MI'
    tempd['cpn'] = 28
    tempd['label'] = 'COSMA7 (2x Intel Skylake 5120, 2.2GHz, 14c)'
    tempd['col'] = cols[0]
    sysdetails['cosma7'] = tempd.copy()
    tempd = {}
    tempd['dir'] = '../results/Tesseract'
    tempd['cpn'] = 24
    tempd['label'] = 'Tesseract (2x Intel Skylake 4116, 2.0GHz, 12c)'
    tempd['col'] = cols[1]
    sysdetails['tesseract'] = tempd.copy()

    nodes = {}
    perf = {}
    for system in systems:
        tempd = sysdetails[system]
        file_list = glob.glob(tempd['dir'] + "/grid_itt_bench_*")

        protodf = []

        for file in file_list:
            rundict = parse_file(file, tempd['cpn'])
            protodf.append(rundict)

        df = pd.DataFrame(protodf)

        print()
        print(tempd['label'])
        nodes[system], perf[system] = get_perf_stats(df, 'max', writestats=True)
    
    for system in systems:
        tempd = sysdetails[system]
        plt.plot(nodes[system], perf[system], marker='+', color=tempd['col'], label=tempd['label'], alpha=0.6)
    plt.xlabel('Nodes')
    plt.ylabel('Performance (Mflop/s per node)')
    plt.legend(loc='best')
    plt.xlim([0,33])
    sns.despine()
    plt.savefig('grid_perf.png', dpi=300)

def parse_file(infile, cpn):

    rundetails = {}
    rundetails['File'] = infile

    # Read the file header
    f = open(infile, "r")
    for line in f:
        if "OpenMP threads" in line:
            s = line.split(':')
            rundetails['Threads'] = int(s[-1])
        elif "MPI tasks" in line:
            s = line.split(':')
            decomp = list(map(int, s[-1].split()))
            rundetails['Ranks'] = np.prod(decomp)
        elif "result:" in line:
            s = line.split()
            rundetails['Perf'] = float(s[10])
    f.close()
    rundetails['Cores'] = int(rundetails['Ranks'] * rundetails['Threads'])
    if rundetails['Cores'] < cpn:
        rundetails['Nodes'] = 1
    else:
        rundetails['Nodes'] = int(rundetails['Cores'] / cpn)
    rundetails['Count'] = 1

    return rundetails

def get_perf_stats(df, stat, threads=None, writestats=False):
    if threads is not None:
       query = '(Threads == {0})'.format(threads)
       df = df.query(query)
    df_num = df.drop(['File'], 1)
    groupf = {'Perf':['min','median','max','mean'], 'Count':'sum'}
    df_group = df_num.sort_values(by='Nodes').groupby(['Nodes','Cores']).agg(groupf)
    if writestats:
        print(df_group)
    # Reduce to nodes only so we get performance per node
    df_group = df_num.sort_values(by='Nodes').groupby(['Nodes']).agg(groupf)
    perf = df_group['Perf',stat].tolist()
    nodes = df_group.index.get_level_values(0).tolist()
    return nodes, perf

main()
