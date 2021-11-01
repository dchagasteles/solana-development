
### Project architecture
1. Someone calls the entrypoint
2. entrypoint forwards the arguments to the processor
3. processor asks instruction.rs to decode the instruction_data from the entrypoint.
4. Using decoded data, processor will now decide which processing function to use to process the request.
5. processor may use state.rs to encode state into or decode the state of an account which has been passed into the entrypoint.