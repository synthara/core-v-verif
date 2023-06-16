The following requirements have to be fullfiled: 

* Develop and integrate “Spike module”
  * Spike DPI (Zbigniew)
  * Comparison logic 
    * SV (decoupled) (1 RTL rvfi, X SIM rvfi)
  * Spike API to control its flow (read/write Spike status) (Mario) (Proposal Friday 16th June)
    * CSR registers than are micro-arch dependant
    * CSR spec may/might
    * Interrupts: follow DUT
    * Debug: follow DUT
    * Config: Proposal: Struct { string param; anytype a; } “top/core1/pmp_regs=0”
  * Valid flow w/o traps, interrupts or debug
  * Step 2: assertions for checking/covering Interrupts/Debug
* Synchronous Traps
* Asynchronous Traps
  * Interrupts
  * Debug

# API

## New Types

```c

class Param 
{
  public:
    Param(string name, any value, string description="");

    .. getters/setters
  
  private:
    string name;
    string description;
    any value;
}

class Params
{
  private:
    std::unordered_map <string,Param> map;

  public:
    param& operator[](string name);
    void set(string name, Param& param);
    Param& get(string name);
}

```

## Simulation subclass

```c

/*
*  Proposed consturctor for the Simulation class
* 
* @param params: parameters to configure the simulation behaviour
*
*/
Simulation(Params& params);

/* 
* Function to load a binary into the system
*/
int loadElf(string path_elf);
/*

/* Function to set parameter 
*
* @param param: Parameter name
* @param value: Parameter value  
*/
void setParam(string param, any value);

/* Function to get parameter 
*
* @param param: Parameter name
* @return:      value of the parameter if exists
*/
any getParam(string param);

/* Function to add a Core to the simulation
*
* @param core: Object of the core
*/
void addCore(core& core);

/* Function to del a Core to the simulation
*
* @param name: name of the core to delete
*/
void delCore(core& core);

/* Function to add a Memory to the simulation
*
* @param memory: Object of the memory
*/
void addMemory(memory& memory);

/* Function to del a Memory to the simulation
*
* @param memory: name of the memory to delete
*/
void delMemory(memory& memory);

/* Function to set a bus in the simulation
*
* @param memory: Object of the bus
*/
void addMemory(bus& bus);

/*
* Function to step the simulation a arbitrary number of instructions 
*
* @param i: number of steps to trigger
* @return:  exit code of the steps (ex. execution has ended) 
*/
int step(int i);

```
## Core subclass
```c

/*
* Proposed constructor for the Processor class
* 
* @param name: Name of the target processor (it can be included in the params)
* @param hart_id: Hart id identifier for the processor (it can be included in the params)
* @param params: parameters to configure the core behaviour
*/
Processor(const string name, const uint32_t hart_id, Params& params);


/* Function to get the current PC
*
* @return:      value of the current PC
*/
uint64_t getPC();

/* Function to set the current PC
*
* @param value: value to set
*/
uint64_t setPC(uint64_t value);

/* Function to get the current Opcode
*
* @return:      value of the current Opcode
*/
uint64_t getOpcode();

/* Function to set the current Opcode
*
* @param value: value to set
*/
void setOpcode(std::vector<uint8_t> value);

/* Function to get the current register
*
* @param name:  name of the target register
* @return:      value of the register
*/
std::vector<uint8_t> getRegValue(string name);

/* Function to set the current register
*
* @param name:  name of the register
* @param value: set value of the register
*/
void setRegValue(string name, std::vector<uint8_t> value);

/* Function to get the register pointer
*
* @param name:  name of the target register
* @return:      register object 
*/
reg_t& getReg(string name);

/* Function to set an arbitrary trap
*
* @param trap:  force processor to take `trap` before the next instruction
*/
uint64_t setTrap(trap_t trap);


/* Function to get the current Mode
*
* @return:      current privilege mode
*/
uint64_t getMode();

/* Function to set current privilege mode
*
* @param mode:  target mode to set in the processor
*/
void setMode(mode_t mode);

```



