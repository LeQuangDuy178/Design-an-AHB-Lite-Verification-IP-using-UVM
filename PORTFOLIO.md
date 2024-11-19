# Design an AHB-Lite Verification IP using UVM
 UVM Testbench to verify AHB Slave with AHB Transaction

--------------------------------------------Project Portfolio-----------------------------------------------------------------

This project is part of the preserved ICTC course "Design Verification - SystemVerilog UVM" by Mr. Huy Nguyen

-------------------------------------------------------------------------------------------------------------------
Section 1: Project Specification

1.1/ AHB Slave Register
- Provided the DUT system UART IP (future projects will develop more), main functional block in this system is the AHB Slave register, where it receives the AHB-lite bus transaction to perform specific instructions based on the input data bus.
![image](https://github.com/user-attachments/assets/9370a48b-2320-41cb-b6bb-0aac1ec88ae6)
- Typically, the AHB-Lite transaction consists of 2 different phases: 1st phase is the address phase, where the address data and other control signals are asserted by the system; 2nd phase is the data phase supporting wait states, where the data is accessed by the system when the ready signal of the slave is asserted (the slave can deassert this signal for delaying suitable clock period for them to handle the data).
- To achieve the completed verification of the register, it is crucial to develop the testbench environment capable for transmitting bus from the external potential AHB-lite master to the AHB slave register inside the UART IP.
- Inside this testbench environment, the AHB Verification IP (AHB VIP) is developed. The approach of this project is to design the AHB VIP that can be reused in another testbench environment in the future projects if needed, just by instance it and perform some slight adjustments in terms of configuration, interface ports, or agent modes.

1.2/ UVM Approach:
- To get the effective design of AHB VIP strengthened in reusability and flexibility, the UVM library resources will be conducted to develop the appropriate components within the VIP.
- Some advancement features in UVM that can be used to develop the VIP for specific components are:
+ The UVM uvm_config_db database stores the crucial memory for every types of data users need to communicate this data among the components. In this project, uvm_config_db will store the virtual interface and the driver, monitor, agent and environment can get the interface through this database.
+ The UVM TLM built-in port/export for sequence and sequence item can be used as the handshake of driver and sequencer to send and receive the transaction easily just by connecting the components in agent and call the functions out. In addition, the driver-sequencer also provides handshake for logical expression to get the proper transaction items at specific times. 
+ The UVM TLM analysis built-in port/export can be used as a handshake for monitor and scoreboard to communicate the transaction with each other.
+ The UVM field macros built-in for uvm_sequence_item enable the transaction when registered via the macros to have some strong features such as sprint(), clone(), compare(), etc.
+ The UVM massage system such as uvm_info, uvm_error, uvm_fatal enable users to print out the appropriate message or errors only when needed, with high effectiveness in terms of display infomation and volume of display verbosity.

-------------------------------------------------------------------------------------------------------------------
Section 2: Testbench Structure

2.1/ Testbench Environment
- The testbench created for this project is almost similar to that of SystemVerilog, but should be more advanced in terms of components and transaction/configuration communication. The structure is shown as followed:
![image](https://github.com/user-attachments/assets/026430ff-b4c4-400e-86df-fca1d5322feb)
- The AHB register DUT is slave role, indicating that the agent should be in master role.

2.2/ Understand AHB VIP
- The AHB VIP should consist of the following components: ahb_transaction, ahb_define, ahb_sequencer, ahb_driver, ahb_monitor, ahb_agent and ahb_if (see folder ahb_vip for more details).
- Wide-known Verfication IP usually consist of these components, some additional components can be built to make it more reliable such as configuration to define more specific control mode via controlling the AHB control signals such as burst type, data size, or transfer mode. 

-------------------------------------------------------------------------------------------------------------------
Section 3: Simulation and Result

3.1/ AHB sequence:
- The sequence has responsibility in creating the appropriate transaction item with pre-defined ahb_transaction packet, then forward it to the driver via sequencer using the built-in method start_item(), finish_item() and get_response() since the response item (AHB address) data is needed for the potential next transaction in the burst. The driver will call get() and put() once it get and send back item to the sequence.

3.2/ Result:
- Generally in this project, 2 sequences are needed, which are ahb_write_sequence and ahb_read_sequence, differentiated in terms of its control signal. The AHB tests will call appropriate sequence to generate the transaction and send to AHB slave to review its behavior.
- See the detailed results in result folder.

-------------------------------------------------------------------------------------------------------------------
Section 4: Summary and Improvement

4.1/ Summary
- The project has covered all of the most basic concepts of UVM that are essential for building every testbench based on UVM library. Throughout developing, the illustration of a basic UVM testbench structure and the communication method between components within the environment in transaction level modelling scale is acknowledged.
- Besides, the understanding in the AHB-lite operation and its application in different IPs can help integrate the it to many other systems to perform bus bridge transition (e.g. the AHB-Lite to AXI bus). 

4.2/ Improvement
- Some of the more advanced UVM concepts, such as UVM report messages, UVM report catacher can be implemented in the scoreboard as a checker to check some expected errors so that the testbench can avoid these cases. However, trying this strategy requires a full understand of the system, otherwise hidden bugs may occur and difficult to fix them.
- The application of multi-layer AHB-Lite may need a specific interconnection for multi masters and slaves, so that the implementation of UVM virtual sequencer or UVM protocol layer may be helpful. 
