#include<string>
#include<iostream>
#include<sstream>
#include<stdlib.h>

using namespace std;

int main(const int argc, const char** argv) {
  int current_row = 0;
  string line, row, col, n, rowbuffer;

  rowbuffer = "";

  // Get each (j, i, n) from STDIN
  while (getline(cin, line)){
    stringstream ss(line);
    getline(ss, row, '\t');
    getline(ss, col, '\t');
    getline(ss, n,   '\t');

    // Check which row the entry belongs on.
    int row_num = atoi(row.c_str());

    // Add to buffer if it belongs on the current row.
    if (current_row == row_num) {
      rowbuffer += (n + " ");
    // Emit the old buffer and add to new buffer if we
    // have started a new row.
    } else {
      cout << rowbuffer << endl;
      current_row = row_num;
      rowbuffer = (n + " ");
    }
  }
  // Print the final row buffer before exiting.
  cout << rowbuffer << endl;
}
