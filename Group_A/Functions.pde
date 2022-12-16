// Finds the number of files in a folder using java.io & java.lang.
int numFiles(String folder) {
  File file = new File(dataPath(folder));
  String[] listPath = file.list();
  return listPath.length;
}

int numIMGs(String folder) {
  File file = new File(dataPath(folder));
  String[] listPath = file.list();
  int count = 0;
  for(int i = 0; i < listPath.length; i++) {
    File f = new File(dataPath(listPath[i]));
    if(f.getName().endsWith(".jpg") || f.getName().endsWith(".png"))
      count++;
  }
  return count;
}

// Copy files from source to destination. Uses java.nio.file;
void copyFiles(String source_path, String dest_path, int numFiles, String extension) throws IOException {
  for(int i = 0; i < numFiles; i++) {
    File source = new File(dataPath(source_path + i + extension));
    File dest = new File(dataPath(dest_path + i + extension));
    Files.copy(source.toPath(), dest.toPath());
  }
}

// Copy files from source to destination. Uses java.nio.file;
void copyFile(String source_path, String dest_path) throws IOException {
    File source = new File(dataPath(source_path));
    File dest = new File(dataPath(dest_path));
    Files.copy(source.toPath(), dest.toPath());
}


// Combines two strings
String insert(String original, String toInsert, int position){
  String p1 = original.substring(0,position);
  String p2 = original.substring(position);
  return p1 + toInsert + p2;
}

// Inserts a new line after a certain amount of characters to account for longer user inputs
String insertNewLines(String sentence, int index) {
  int lines = floor(sentence.length()/index);
  for(int j = 0; j < lines; j++) {
    int i = index * (j + 1);
    if(i > sentence.length()) {
      i = sentence.length();
    }
    char c = sentence.charAt(i);
    while(c != ' ' && i > 1) {
      i--;
      c = sentence.charAt(i);
    }
    sentence = insert(sentence, "\n", i);
  }
  return sentence;
}

// Retrieves the path of the last modified file in a folder
String getLastModified(String path) {
    File directory = new File(path);
    File[] files = directory.listFiles(File::isFile);
    long lastModifiedTime = Long.MIN_VALUE;
    File chosenFile = null;
    if (files != null)
    {
        for (File file : files)
        {
            if (file.lastModified() > lastModifiedTime)
            {
                chosenFile = file;
                lastModifiedTime = file.lastModified();
            }
        }
    }
    String filePath = chosenFile.getAbsolutePath(); 
    return filePath;
}
