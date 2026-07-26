# Sorting-algorithm-comparator-in-AVR
> AVR Assembly implementation of Bubble Sort, Selection Sort, and Insertion Sort on ATmega32 microcontroller

---

##  About the Project

This project implements and compares three classical sorting algorithms written entirely in **AVR Assembly language**, targeting the **ATmega32 microcontroller**. The comparison is done using AVR Studio's built-in **Cycle Counter** and **Stopwatch** to measure the performance of each algorithm at the hardware level.

Since the project is purely software-based, **no external hardware** is required — everything runs in the AVR Studio simulator.

---

##  Algorithms Implemented

### 1. Bubble Sort
Repeatedly compares adjacent elements and swaps them if they are in the wrong order. Largest element bubbles up to the end after each pass.
- **Best Case:** O(n)
- **Worst Case:** O(n²)
- **Swaps:** O(n²) — highest among the three

### 2. Selection Sort
Finds the minimum element from the unsorted portion and places it at the correct position. Grows the sorted portion one element at a time.
- **Best Case:** O(n²)
- **Worst Case:** O(n²)
- **Swaps:** O(n) — at most N-1 swaps only

### 3. Insertion Sort
Picks one element at a time and inserts it into its correct position within the already sorted portion. Similar to sorting playing cards in hand.
- **Best Case:** O(n)
- **Worst Case:** O(n²)
- **Swaps:** O(n²) — shifts instead of swaps

---

## Project Structure

```
Sorting-Algorithm-Comparator/
│
├── main.asm          # Main AVR Assembly source file
├── m32def.inc        # ATmega32 definition file (AVR Studio default)
└── README.md         # Project documentation
```

---

##  How to Run

### Prerequisites
- [Atmel Studio](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio) (AVR Studio 4/5 or Microchip Studio)
- ATmega32 selected as target device
- Simulator mode (no hardware needed)

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/ridamir039-rgb/Sorting-Algorithm-comparator-in-AVR.git
```

**2. Open in AVR Studio**
- Open Atmel Studio
- File → Open → Project/Solution
- Select the `.aps` or `.atsln` project file

**3. Build the project**
- Build → Build Solution (F7)
- Make sure there are no errors

**4. Start Simulation**
- Debug → Start Debugging (F5)
- Make sure target is set to **Simulator** (not hardware)

---

## How to Observe Results

### Open these windows in AVR Studio:
| Window | How to Open |
|---|---|
| Processor Status | Debug → Processor Status |
| Memory Window | View → Memory → select `data IRAM` |
| Register Window | View → Registers |

### Watching the Array in Memory
- In Memory window → select **`data IRAM`**
- Set address to **`0x0060`**
- You will see 10 bytes representing the array

### Input Array (loaded before each sort):
```
09  03  07  01  05  08  02  06  04  00
```

### Expected Output (after each sort):
```
00  01  02  03  04  05  06  07  08  09
```

---

##  Measuring Performance

Since the cycle counter accumulates throughout execution, use this method:

| Step | Action |
|---|---|
| 1 | Note Cycle Counter **before** `rcall SORT_NAME` |
| 2 | Press F10 to run the sort subroutine |
| 3 | Note Cycle Counter **after** it returns |
| 4 | **Cycles = After − Before** |

### Sample Results (10 elements, random input)

| Algorithm | Cycles Used | Relative Performance |
|---|---|---|
| Bubble Sort | ~2000+ | Slowest |
| Selection Sort | ~988 | Fastest |
| Insertion Sort | ~989 | Close second |

> **Note:** Selection Sort and Insertion Sort are nearly identical for small arrays — only 1 cycle difference observed in simulation.

---

## Key AVR Concepts Used

| Concept | Instructions |
|---|---|
| Pointer registers | X (r27:r26), Y (r29:r28) |
| Post-increment addressing | `ld r, X+` / `st X+, r` |
| Pre-decrement addressing | `ld r, -X` |
| Indexed SRAM access | `add XL, rN` + carry handling |
| Subroutine calls | `rcall` / `ret` |
| Comparison & branching | `cp`, `cpi`, `breq`, `brlo`, `brge` |
| Stack pointer setup | `out SPL` / `out SPH` |

---

## Register Map

| Register | Role |
|---|---|
| r16 | General purpose / stack setup |
| r17 | arr[i+1] in Bubble Sort |
| r20 | Outer loop index (i) |
| r21 | Inner loop index (j) / key in Insertion Sort |
| r22 | min_index in Selection / j in Insertion |
| r23 | min value in Selection / arr[j] in Insertion |
| r24, r25 | Temporary swap values |
| X (r27:r26) | Primary array pointer |
| Y (r29:r28) | Secondary pointer for swap |

---

## References

- Atmel Corporation, *ATmega32 Datasheet*, Microchip Technology Inc.
- Atmel Corporation, *AVR Instruction Set Manual*, Microchip Technology Inc.
- T. H. Cormen et al., *Introduction to Algorithms*, 3rd ed., MIT Press, 2009.
- M. A. Mazidi et al., *AVR Microcontroller and Embedded Systems*, Pearson, 2011.
- Documentation of the project included in this repository: https://github.com/ridamir039-rgb/Sorting-algorithm-comparator-in-AVR/blob/main/Semester_Project/Project_Report.pdf

---
