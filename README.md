# 🧩 Maze Game – FPGA Implementation

## 📌 Overview
**Maze Game** is an FPGA-based interactive project implemented on a **Xilinx Spartan-3E** board.  
The player controls a **red square** using **W, S, A, D** keys on a **PS/2 keyboard** and must navigate through a static maze to reach the **green square** goal.  
The game is displayed on a **VGA monitor** with a resolution of **600×440 pixels**, using distinct colors for different elements:

- 🟥 **Red** – Player  
- 🟩 **Green** – Goal  
- 🟦 **Blue** – Maze walls  
- ⚪ **White** – Background  

The game includes:
- **Collision detection** to prevent passing through walls  
- **Step-by-step movement** with controlled delay  
- **Win detection** when reaching the goal  

---

## 🎮 Features
- Fully implemented in **VHDL**
- **VGA output** with pixel-level rendering
- **PS/2 keyboard** input handling
- **Static maze generation** with precise wall placement
- **Smooth gameplay** with controlled movement speed
- **Goal detection** and game end condition

---

## 🚀 How It Works
1. **Startup:** Player starts in the **top-left corner** of the maze  
2. **Controls:**  
   - **W** – Move up  
   - **S** – Move down  
   - **A** – Move left  
   - **D** – Move right  
3. **Rules:**  
   - Cannot pass through **blue walls**  
   - Movement speed is limited via a **delay counter**  
4. **Goal:** Reach the **green square** to win  

---

## 🎥 Video Demo
[▶ Click here to watch the gameplay](https://drive.google.com/file/d/1MHUfjJu36sIHbTLP1JHhTPMylOfIy-2f/view?usp=sharing)

---

## 🛠 Hardware Requirements
- **Xilinx Spartan-3E FPGA Board**
- **VGA monitor**
- **PS/2 keyboard**
- VGA & PS/2 cables

---

## 💡 Future Improvements
- Multiple maze levels
- Moving obstacles
- Score & time tracking
- Sound effects
- Adjustable difficulty levels

---
