#include<string>
#include<iostream>
#include<sstream>
#include<stdlib.h>

using namespace std;

int main(const int argc, const char** argv) {
  int current_row = -1;
  istringstream instream;
  string line, row, col, n, rowbuffer;

  rowbuffer = "";

    while (getline(cin, line)){
      stringstream ss(line);
        getline(ss, row, '\t');
        getline(ss, col, '\t');
        getline(ss, n,   '\t');
        cout << "Row is " << row << endl;
        cout << "Col is " << col << endl;
        cout << "N   is " << n   << endl;

        int row_num = atoi(row.c_str());

        if (current_row == row_num) {
          rowbuffer += (n + " ");
        } else {
          cout << rowbuffer << endl;
          current_row = row_num;
          rowbuffer = (n + " ");
        }
    }
    cout << rowbuffer << endl;
}
