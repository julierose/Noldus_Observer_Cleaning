# Cleaning scripts

Both scripts use the same input, which are raw data exports from the Noldus Observer program. The export contains both abundance and behavior data.

Data are exported as .xlsx files

Behavior-cleaning extracts, cleans, and formats fish and invertebrate behavior data 

MaxN_clean extracts, cleans, and formats fish and invertebrate abundance (MaxN) data.

Attributes are stored in the column 'Observation', separated with underscore,
using a consistent order

Important to note that the datetime columns refer to when the video was
scored, not when the video was created!! Need to extract video datetime from Observation column

Behavior analysis is very labor-intensive, and these files are generated
slowly. I like to perform QC as the process is ongoing rather than batch
process files at the end. So I have deliberately opted to not include 
iterations for batch processing.
