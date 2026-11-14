# NorthBank UK – PL/SQL Group Project

All code is in `T1_to_T9.sql`. Run the whole file from top to bottom. The results are in `output.txt`.

**Assumption:** we used the standard NorthBank column names (for example `branch_city`, `assets`, `customer_city`, `amount`, `balance`).

## T1 – View
We made a view called `vw_account_branch`. It joins the `account` table with the `branch` table on `branch_name`. For each account it shows the account number, the balance and the branch's city.

## T2 – Block and variables
The block counts the customers and adds up all the account balances, then prints both on one line. We used `NVL` so the total shows 0 instead of nothing if there are no accounts. The balance variable uses `%TYPE`, so it has the same data type as the column.

## T3 – IF / ELSE
The block loops through every branch. If a branch has £200 million or more in assets it prints **Major**, otherwise **Local**. The £200 million limit is stored in a constant, so it's easy to change.

## T4 – Cursor
We made a cursor that finds all loans over £500,000. We open it, fetch the rows one by one and print each one, and stop when there are no more rows. At the end we print how many loans were found using `%ROWCOUNT`, then close the cursor.

## T5 – Exceptions
The user types a customer name and the block prints that customer's city. If the name doesn't exist, the `NO_DATA_FOUND` error is caught and a friendly message is printed instead of crashing. Any other error is caught by `WHEN OTHERS`, which prints the error code and message.

## T6 – Procedure
`sp_add_customer` adds a new customer. First it checks whether the name already exists. If it does, it stops with error -20001. If not, it inserts the customer and saves with `COMMIT`. If anything goes wrong it undoes the change with `ROLLBACK`. We tested it by adding a customer once (it works) and then adding the same customer again (it's rejected).

## T7 – Functions
- `fn_customer_balance` returns a customer's total money across all their accounts, or 0 if they have no accounts.
- `fn_assets_band` returns **Big** if a branch has £200 million or more in assets, otherwise **Small**.

We tested both with normal `SELECT` statements.

## T8 – Trigger
We created a `loan_log` table. The trigger `trg_loan_insert` runs automatically every time a new loan is added. It saves the loan number, the amount, the user who added it and the time. We tested it by adding a test loan and then looking at `loan_log`.

## T9 – Integration
`sp_post_interest` goes through every account. It uses `fn_assets_band` from T7 to check whether the account's branch is Big. If it is, it adds 1% interest, rounded to 2 decimal places. At the end it prints how many accounts got interest and the total amount paid. Changes are only saved if everything works; if there's an error, all the changes are undone.
