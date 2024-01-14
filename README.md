<!-- LTeX: language=en-US -->

# Randomized Distributed Algorithm Simulator

## Overview

This project aims to provide a centralized implementation to simulate a randomized distributed algorithm.
The primary focus is to handle a graph `G = (V, E)` with a maximum degree of `∆`, effectively simulating the distributed randomized `(∆ + 1)`-coloring
algorithm until every vertex within the graph is successfully colored. This is done for 100 random regular graphs with various randomly selected
parameters (size of the graph, maximum degree) and 100 random unweighted graph with various randomly selected parameters (size of the graph, maximum degree, number of edges).
The resulting colorings are tested if they are proper.

## Implementation Details

- **Julia Version Compatibility**: The script is compatible was tested with the versions 1.9 and 1.10 (as of writing the latest) of Julia.

## Installation and Usage

To facilitate an effortless setup and execution process, a Makefile is included:

- **Installation**:
  - Run `make install` to install the latest version of Julia along with all necessary dependencies required by the script.
- **Execution**:
  - Simply execute `make run` to start the program. This command also handles any additional dependency installations.
- **Cleanup**:
  - To uninstall Julia and remove all related packages, use `make clean`.

### Platform Compatibility

The Makefile is designed to be cross-platform, ensuring compatibility with:

- Windows (Note: Requires `winget` for package management)
- Linux
- macOS

Test Status: Successfully tested on Linux.
