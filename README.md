### Create Python Module of the C++ Code / Class

***Prerequisite***
- Python
- Pybind11 module
- Eclipse or any other compiler
- MingW64

***Project Structure***

![Alt text](./images/project_structure.jpg?raw=true "project_structure")

Above image shows the the structure.

- **build:** I am using this folder to create and store the object files. (used in g++ commands)
- **python_implementation:** This folder consist of dynamic python module, pybind11.cpp. I am using this location in commands to create pyd module.

***How to execute?***

**1. Make sure you have MingW64 installed**

**2. Install pybind11 library in an python venv**

**3. Activate venv**
- Get the pybind11 paths by running the **get_pybind11_paths.py** from python_implementation folder.

**4. Add respective paths and file anmes in build_pyd_automate.bat**

**5. Activate virtual environment**

**6. Run the build_pyd_automate.bat file to create .pyd module**