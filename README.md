# UART_Verilog
Designed and implemented an UART using Verilog (Baud Rate variation included)

# UART 
## How UART Works?
In UART Serial Communication, the data is transmitted asynchronously i.e. there is no clock or other timing signal involved between the sender and receiver. Instead of clock signal, UART uses some special bits called Start and Stop bits.

These bits are added to the actual data packet at the beginning and end respectively. These additional bits allows the receiving UART to identify the actual data.

## What is Baud Rate?
The speed at which the data is transmitted is mentioned using Baud Rate. Both the transmitting UART and Receiving UART must agree on the Baud Rate for a successful data transmission.
