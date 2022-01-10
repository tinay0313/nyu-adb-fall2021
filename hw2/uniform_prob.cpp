#include <stdio.h>
#include <algorithm>
#include <iostream>
#include <cstring>
#include <vector>
#include <fstream>
#include <ctime>

using namespace std;

/**
 * @brief generate a vector of uniformly distributed numbers from
 *          1 to N (inclusive)
 * 
 * @param N numbers from 1 to N (inclusive)
 * @return vector<int> resulting vector of N numbers uniformly distributed
 */
vector<int> gen(int N)
{
    vector<int> p(N);

    // generate numbers 1 to N
    for(int i = 1; i <= N; ++i) {
        p[i - 1] = i;
    }

    return p;
}

int main(int argc, char* argv[])
{
    vector<int> outvec = gen(70002);
    
    FILE * myfile;
    myfile = fopen("trade_uniform.csv", "w");
    fprintf(myfile, "stock,time,qty,price\n");
    
    srand(time(NULL));
    // quantity ranges uniformly from 100 to 10000
    int qty_range = 10000 - 100 + 1;
    // price ranges uniformly from 50 to 500
    int price_range = 500 - 50 + 1;
    // price of a stock changes uniformly from -5 to -1
    // or from 1 to 5
    int delta_price_range = 5;
    // stock id ranges uniformly out of the fractally
    // distributed stock symbols
    int idx_range = outvec.size();
    
    // random quantity with range qty_range
    int rand_qty = rand() % qty_range + 100;
    // random price with range price_range
    int rand_price = rand() % price_range + 50;
    // random change in price with range delta_price_range
    int rand_delta_price = rand() % delta_price_range + 1;
    // random index to select from outvec with range idx_range
    int rand_idx = rand() % idx_range;
    // random factor that determines whether a stock's price
    // increases or decreases
    int rand_pos_neg = rand() % 2;

    int timestamp = 1;
    vector<int> stock_price(outvec.size(), -1);

    while(timestamp <= 10000000) {
        int stock = outvec[rand_idx];
        int qty = rand_qty;

        if(stock_price[stock] < 0) {
            // if first time pick stock, give it
            // a price
            stock_price[stock] = rand_price;
        } else {
            // stock had a price before so change its price
            // per rand_delta_price and rand_pos_neg
            if(rand_pos_neg) {
                stock_price[stock] = min(500, stock_price[stock] + rand_delta_price);
            } else {
                stock_price[stock] = max(50, stock_price[stock] - rand_delta_price);
            }
        }
        fprintf(myfile, "s%d,%d,%d,%d\n", stock, timestamp, qty, stock_price[stock]);
        ++timestamp;
        
        rand_qty = rand() % qty_range + 100;
        rand_price = rand() % price_range + 50;
        rand_delta_price = rand() % delta_price_range + 1;
        rand_idx = rand() % idx_range + 1;
        rand_pos_neg = rand() % 2;
    }

    fclose(myfile);
    return EXIT_SUCCESS;
}