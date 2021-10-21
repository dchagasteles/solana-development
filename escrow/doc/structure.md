
### Project architecture
1. Someone calls the entrypoint
2. The entrypoint forwards the arguments to the processor
3. The processor asks instruction.rs to decode the instruction_data argument from the entrypoint function.
4. Using the decoded data, the processor will now decide which processing function to use to process the request.
5. The processor may use state.rs to encode state into or decode the state of an account which has been passed into the entrypoint.