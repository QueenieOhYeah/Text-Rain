# Text Rain
Ziqian Qiu

### Design Decisions
1. I created three streams of text rain, the text contents are ```THIS IS A TEXT RAIN```, ```new rain added to the scene``` and ```This is for CSCI4611"``` respectively. Each stream of rain is randomly assign a color.

2. Each stream of rain is created after running draw() for 200 times after the creation of previous rain.

3. Use a pseudo-random algorithm to imitate the randomness of each stream of rain at its creation.
  * I firstly random assign integer between -400 and 0 as y coordination of each letters so that they are above the screen at the beginning.
  * The x coordination increases for each letter in a text so that they can be read in order if stopped.
  * The intervals between letters are assigned as a (random integer between 1 and 5) times (width of previous letter).
  * When the y coordination of a letter increases to the height of scene, it will be assigned an integer between -400 and 0 again. Therefore, the rain can reuse without creating more new ones.
  * Each letter is assigned with random speed between 1 to 5 pixels per second.

4. When pressing spacebar, the image will becomes only black and white. I did this by using filter in the mode of THRESHOLD.

5. Procedure of creating mirror effect is
  * Store the original image in img
  * Reverting the order of pixels on each row and store in inputImage by formula: ```img.pixels[i-i%img.width+(img.width-1)-i%img.width]``` where i is the index from 0 to the length of img.pixels.

6. Use font "Times-Bold" at size 20.
