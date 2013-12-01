#include<string>
#include<iostream>
#include<sstream>

using namespace std;

int main(const int argc, const char** argv) {
    int current_row = -1;
    string line;

    while (cin >> line){
        istringstream iss(line);
        string row, col, n;
        iss >> row;
        iss >> col;
        iss >> n;

        int row_num = atoi(row.c_str());

        if (current_row == row_num) cout << "n ";
        else {
            current_row = row_num;
            cout << "\nn ";
        }
    }
    cout << endl;
}
