# apk-editor

This tool is fairly easy to use.

Setting up the framework is the most common mistake people make.

To set up framework first copy your framework-res.apk(s) to your desktop.  Navigate to the z-install frameworks folder.  

Inside it you will find a file called apktool-if.cmd.  Take the framework-res.apk file(s) from your desktop and drag and drop 

it on that file.  A small cmd window should open up and inform you the framework has been installed.  If you get an error message 

or it force closes on you immediately that is because you did not copy them to your desktop first.

Once you run the command to re-compile your apk (2) you will not need to 7zip, copy anything over to original apk or anything.  just follow the prompts and it will do it's thing for you and will build and be ready to flash.  

If you need to sign your apk all you do is select option 3 once it has built.  

You do not need to place the "unsigned.apk" to the "place-apk-here-for-signing" folder.   That folder is for signing 

unsigned apks that have not been signed using this tool.  Example: your friend sends you an unsigned apk and asks you to 

sign it because they don't know how.  In this case you would place the apk in that folder and select option 16.  The cmd 

window will change color to green and the apk will be signed.

The rest is fairly straight forward.

Enjoy!
