# Password-based-image-encryption
This project likely deals with encrypting images using a combination of two techniques: chaotic maps and Linear Feedback Shift Registers (LFSRs).It encrypts the image using a password. The password is transformed into a keystream using a chaotic map and a Linear Feedback Shift Register (LFSR) for randomness. This keystream is then used to shuffle the pixel locations (confusion) and modify the pixel values (diffusion) of the image, making it unreadable. The same password is required to decrypt the image by reversing these steps. This method leverages the unpredictable nature of chaotic maps and the efficiency of LFSRs to create a secure and password-dependent image encryption scheme.

Here's a breakdown of the steps involved:
- Plain Image: The process starts with the original image, which is referred to as the plain image in the flowchart.
- Password to Key Generation: The user creates a password, which is then used to generate an encryption key. This key is crucial for encrypting and decrypting the image.
- Image to 3D Matrix: The plain image is converted into a 3D matrix. Images are typically represented in 2D using rows and columns. Here, an additional dimension is added, likely to perform operations on the image data more efficiently.
- 2D Matrix Split: The 3D matrix is split into two separate 2D matrices.
- Substitution: Each of the 2D matrices undergoes a substitution process. This involves replacing image data values with different values according to an algorithm. This is a common encryption technique to scramble the image data.

User Key & Chaotic Map: Here, two processes occur:
The user-generated key is incorporated into the encryption process.A chaotic map is applied. Chaotic maps are mathematical functions that exhibit unpredictable behavior. 
- LFSR (Linear Feedback Shift Register):  An LFSR (Linear Feedback Shift Register) is used. LFSRs are a type of digital circuit that can generate a sequence of pseudo-random bits. In this context, it likely creates a random bit stream that is used in the encryption process.
- Key Generation (K1 & K2): The chaotic map and LFSR together generate two keys, K1 and K2. These keys are likely derived from the user-provided password, the chaotic map’s unpredictable behavior, and the random bitstream from the LFSR.
- XOR Operation:  An XOR operation is performed on the two permuted matrices and the two generated keys (K1 and K2). XOR (exclusive OR) is a bitwise operation that outputs a 1 if the corresponding bits in its operands are different, and a 0 if they are the same. This operation likely combines the image data with the keys to create the encrypted version.
- Encryption Function: The XOR operation’s output is passed through an encryption function. This function likely performs additional mathematical operations on the data to further scramble it and make it resistant to decryption without the proper key.

The result of the encryption function is the encrypted image. This image appears garbled and unintelligible without the decryption process and the corresponding key.

## INPUT IMAGE
![lena](https://github.com/user-attachments/assets/92cef19f-18d1-4dc7-a18f-6ef4f190698b)

![image](https://github.com/user-attachments/assets/85f843fb-81f4-4de3-8642-4d6e6da6cc10)


