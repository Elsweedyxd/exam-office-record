-- =====================================================================
--  NORTHBANK UK - PL/SQL GROUP PROJECT TEMPLATE
--  Course: 5FTCS2090 - PL/SQL Programming
--  Coursework: 1 (Part A - Group Project)
--  Weight: 25% of module mark
--  Submission deadline: Sunday 15 November 2026, 23:59
-- =====================================================================
--
--  GROUP DETAILS (fill in before submitting)
--  ------------------------------------------
--  Group number:   Group 19
--
--  Member 1 name:  Daniel Shenuda   UH ID:  24075833
--  Member 2 name:  Ahmed sharif     UH ID:  24119908
--  Member 3 name:  Mohamed Elsweedy   UH ID:  24074767
--  Member 4 name:  Monzir mohamed   UH ID: 24127341
--
--  Date submitted: 14/11/2026
--
-- =====================================================================
--  HOW TO RUN THIS FILE IN ORACLE DATABASE ACTIONS
--  -------------------------------------------------
--   1. Open Database Actions (the web console for your Oracle 26ai
--      instance). Launch "SQL" (SQL Worksheet).
--   2. Use the "Open" (folder) icon to load this file, or paste its
--      contents into the worksheet.
--   3. Click "Run Script" (or press F5) to execute the WHOLE file.
--      Do NOT use "Run Statement" (Ctrl+Enter) - it runs one
--      statement at a time and may miss the PL/SQL blocks.
--   4. The output appears in the "Script Output" tab at the bottom
--      of the page. DBMS_OUTPUT text is captured automatically -
--      you do NOT need SET SERVEROUTPUT.
--   5. To capture output.txt:
--        - Click the download icon on the Script Output tab, OR
--        - Select all text in the tab, copy, paste into a plain
--          text file, and save as output.txt.
--   6. If you are running this file in SQLcl or SQL*Plus instead
--      of Database Actions, uncomment the following line:
--         SET SERVEROUTPUT ON SIZE UNLIMITED
--
-- =====================================================================
--  HOW TO USE THIS TEMPLATE
--  ------------------------
--  * Each task has PROBLEM, WHAT TO WRITE, and RUBRIC sections.
--  * Write your code between the two markers:
--        ---- YOUR CODE STARTS HERE ----
--        ---- YOUR CODE ENDS HERE ----
--  * Do not delete the rubric comments or the banner lines -
--    they are your self-check and mark the task boundaries in
--    output.txt.
--  * Keep the task order unchanged: T9 depends on the function
--    defined in T7, and T8's trigger fires on inserts into loan.
--
--  ABOUT THE RUBRIC
--  ----------------
--  The rubric in each task is a SELF-EVALUATION GUIDE, not the
--  final mark. The project is graded through a short DISCUSSION
--  (viva) with your instructors after submission. The final mark
--  reflects both the submitted scripts and each member's
--  demonstrated understanding.
--
--  PREREQUISITES
--  -------------
--  You must have run the seed script (seed_northbank.sql) in the
--  same schema before running this file. That creates and populates:
--      BRANCH, CUSTOMER, LOAN, BORROWER, ACCOUNT, DEPOSITOR
--
--  Note on customer names: they are stored as
--    'James Smith (C-000123)'
--  When a task asks you to reference a customer name, include the
--  (C-XXXXXX) suffix exactly as it appears in the CUSTOMER table.
-- =====================================================================


-- =====================================================================
--  TASK T1 - VIEW                                          (10 marks)
-- =====================================================================
--  PROBLEM
--    The reporting team wants a single view of all accounts, with the
--    city of the branch that holds each account.
--
--  WHAT TO WRITE
--    A view named  vw_account_branch  with columns:
--        account_number, balance, branch_city
--    Test with:  SELECT * FROM vw_account_branch WHERE ROWNUM <= 5;
--
--  RUBRIC (10) - SELF-EVALUATION GUIDE
--    [ ] 2  View compiles without errors
--    [ ] 4  Correct join on branch_name
--    [ ] 2  Correct column list and order
--    [ ] 2  Test SELECT executed and shown
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T1 - VIEW =====');
END;
/

---- YOUR CODE STARTS HERE ----
CREATE OR REPLACE VIEW vw_account_branch AS
SELECT a.account_number,
       a.balance,
       b.branch_city
FROM   account a
JOIN   branch  b ON b.branch_name = a.branch_name;


SELECT * FROM vw_account_branch WHERE ROWNUM <= 5;


---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T2 - BLOCK, VARIABLES, PRINTING                    (10 marks)
-- =====================================================================
--  PROBLEM
--    A one-line monthly summary: how many customers the bank has and
--    how much it holds in total across all accounts.
--
--  WHAT TO WRITE
--    An anonymous block that prints exactly one line:
--        Customers: <count>   Total balance: <amount>
--    Use a variable declared with %TYPE.
--
--  RUBRIC (10) - SELF-EVALUATION GUIDE
--    [ ] 2  Block compiles and runs
--    [ ] 2  Correct COUNT(*) from customer
--    [ ] 3  Correct SUM from account with NVL
--    [ ] 1  %TYPE used on at least one variable
--    [ ] 2  Output matches the required format
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T2 - BLOCK, VARIABLES, PRINTING =====');
END;
/

---- YOUR CODE STARTS HERE ----
DECLARE
    v_customers  PLS_INTEGER;
    v_total      account.balance%TYPE;
BEGIN
    SELECT COUNT(*)
    INTO   v_customers
    FROM   customer;

    SELECT NVL(SUM(balance), 0)
    INTO   v_total
    FROM   account;

    DBMS_OUTPUT.PUT_LINE('Customers : ' || v_customers ||
                         '    Total balance : ' ||
                         TRIM(TO_CHAR(v_total, '999,999,990.00')));
END;
/



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T3 - IF / CASE                                     (10 marks)
-- =====================================================================
--  PROBLEM
--    Classify branches as 'Major' (assets >= 200,000,000) or 'Local'
--    (below 200,000,000) and print each branch with its class.
--
--  WHAT TO WRITE
--    An anonymous block that loops over all branches and prints
--    branch_name, assets, and the classification.
--
--  RUBRIC (10) - SELF-EVALUATION GUIDE
--    [ ] 2  Block compiles and runs
--    [ ] 2  Threshold declared as a named constant
--    [ ] 3  Loop iterates over all branches
--    [ ] 2  Correct IF/ELSE classification
--    [ ] 1  Output readable and formatted
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T3 - IF / CASE =====');
END;
/

---- YOUR CODE STARTS HERE ----
DECLARE
    c_major_threshold CONSTANT NUMBER := 200000000;   -- GBP 200 M
    v_class           VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Branch', 25) || LPAD('Assets', 20) || '  Class');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 54, '-'));

    FOR b IN (SELECT branch_name, assets
              FROM   branch
              ORDER  BY branch_name)
    LOOP
        IF b.assets >= c_major_threshold THEN
            v_class := 'Major';
        ELSE
            v_class := 'Local';
        END IF;

        DBMS_OUTPUT.PUT_LINE(RPAD(b.branch_name, 25) ||
                             LPAD(TO_CHAR(b.assets, '999,999,999,990.00'), 20) ||
                             '  ' || v_class);
    END LOOP;
END;
/



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T4 - CURSOR                                        (10 marks)
-- =====================================================================
--  PROBLEM
--    The auditor wants a list of every loan over 500,000.
--
--  WHAT TO WRITE
--    An anonymous block that declares an explicit cursor over loans
--    with amount > 500000, opens it, fetches each row, prints it, and
--    closes it. Print the total count with %ROWCOUNT.
--
--  RUBRIC (10) - SELF-EVALUATION GUIDE
--    [ ] 3  Cursor declared with the correct filter
--    [ ] 3  OPEN, FETCH, CLOSE used properly
--    [ ] 2  EXIT WHEN %NOTFOUND
--    [ ] 1  %ROWCOUNT printed
--    [ ] 1  Output readable
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T4 - CURSOR =====');
END;
/

---- YOUR CODE STARTS HERE ----
DECLARE
    CURSOR c_large_loans IS
        SELECT loan_number, branch_name, amount
        FROM   loan
        WHERE  amount > 500000
        ORDER  BY amount DESC;

    v_loan   c_large_loans%ROWTYPE;
    v_count  PLS_INTEGER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('Loan', 15) || RPAD('Branch', 25) || LPAD('Amount', 18));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 58, '-'));

    OPEN c_large_loans;
    LOOP
        FETCH c_large_loans INTO v_loan;
        EXIT WHEN c_large_loans%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_loan.loan_number, 15) ||
                             RPAD(v_loan.branch_name, 25) ||
                             LPAD(TO_CHAR(v_loan.amount, '999,999,990.00'), 18));
    END LOOP;
    v_count := c_large_loans%ROWCOUNT;
    CLOSE c_large_loans;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 58, '-'));
    DBMS_OUTPUT.PUT_LINE('Loans over 500,000 : ' || v_count);
END;
/



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T5 - EXCEPTIONS                                    (10 marks)
-- =====================================================================
--  PROBLEM
--    A lookup tool accepts a customer name and prints their city.
--    If the customer does not exist, the tool must say so politely
--    and must not crash the session.
--
--  WHAT TO WRITE
--    An anonymous block that reads a name, selects the customer's
--    city into a variable, prints the result, and handles the
--    missing-customer case.
--
--  NOTE FOR DATABASE ACTIONS
--    Database Actions does not support the SQL*Plus ACCEPT command,
--    so you cannot prompt the user. Instead, declare a variable and
--    hard-code the test name, e.g.:
--
--        v_name customer.customer_name%TYPE :=
--            'James Smith (C-000123)';
--
--    To test a different customer, edit the string and re-run.
--    Pick a real name from:
--        SELECT customer_name FROM customer WHERE ROWNUM <= 5;
--
--  RUBRIC (10) - SELF-EVALUATION GUIDE
--    [ ] 2  Block compiles and runs
--    [ ] 3  Correct SELECT ... INTO from customer
--    [ ] 3  NO_DATA_FOUND handled with the right message
--    [ ] 2  WHEN OTHERS with SQLCODE / SQLERRM
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T5 - EXCEPTIONS =====');
END;
/

---- YOUR CODE STARTS HERE ----
SET DEFINE ON
SET VERIFY OFF
ACCEPT p_name PROMPT 'Enter customer name: '

DECLARE
    v_name  customer.customer_name%TYPE := '&p_name';
    v_city  customer.customer_city%TYPE;
BEGIN
    SELECT customer_city
    INTO   v_city
    FROM   customer
    WHERE  customer_name = v_name;

    DBMS_OUTPUT.PUT_LINE('Customer ' || v_name || ' lives in ' || v_city || '.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Sorry, no customer named "' || v_name ||
                             '" was found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error ' || SQLCODE || ': ' || SQLERRM);
END;
/
SET DEFINE OFF




---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T6 - PROCEDURE                                     (12 marks)
-- =====================================================================
--  PROBLEM
--    Front-desk staff need a routine that adds a new customer. If the
--    customer already exists, it must stop with a clear message
--    rather than insert a duplicate.
--
--  WHAT TO WRITE
--    A stored procedure with ONLY IN parameters:
--        sp_add_customer(p_name   IN VARCHAR2,
--                        p_street IN VARCHAR2,
--                        p_city   IN VARCHAR2)
--    It checks whether p_name already exists, raises a business error
--    if it does, otherwise inserts the row and commits. On any error
--    it rolls back.
--
--  NOTE FOR DATABASE ACTIONS
--    After writing the procedure, add a short test at the end:
--        BEGIN
--          sp_add_customer('Test User', '1 Test St', 'London');
--        END;
--        /
--    The duplicate test should raise ORA-20001; that is expected
--    and will appear as an error line in the Script Output tab.
--
--  RUBRIC (12) - SELF-EVALUATION GUIDE
--    [ ] 3  Correct signature and compiles
--    [ ] 3  Existence check using COUNT(*)
--    [ ] 3  RAISE_APPLICATION_ERROR on duplicate
--    [ ] 2  COMMIT on success / ROLLBACK on failure
--    [ ] 1  Tested with a call
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T6 - PROCEDURE =====');
END;
/

---- YOUR CODE STARTS HERE ----
CREATE OR REPLACE PROCEDURE sp_add_customer (
    p_name   IN VARCHAR2,
    p_street IN VARCHAR2,
    p_city   IN VARCHAR2
) AS
    v_cnt  PLS_INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO   v_cnt
    FROM   customer
    WHERE  customer_name = p_name;

    IF v_cnt > 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Customer "' || p_name || '" already exists - not added.');
    END IF;

    INSERT INTO customer (customer_name, customer_street, customer_city)
    VALUES (p_name, p_street, p_city);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer "' || p_name || '" added.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_add_customer;
/



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T7 - FUNCTIONS                                     (12 marks)
-- =====================================================================
--  PROBLEM
--    Two small helpers that can be called directly from SQL.
--
--  WHAT TO WRITE
--    1. fn_customer_balance(p_customer IN VARCHAR2) RETURN NUMBER
--          Returns the customer's total account balance, or 0 for a
--          customer who holds no accounts.
--    2. fn_assets_band(p_branch IN VARCHAR2) RETURN VARCHAR2
--          Returns 'Big' if assets >= 200,000,000, otherwise 'Small'.
--
--  RUBRIC (12) - SELF-EVALUATION GUIDE
--    [ ] 2  Both functions compile
--    [ ] 4  fn_customer_balance returns correct sum with NVL
--    [ ] 4  fn_assets_band uses correct threshold and returns label
--    [ ] 2  Both functions tested from plain SQL
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T7 - FUNCTIONS =====');
END;
/

---- YOUR CODE STARTS HERE ----
CREATE OR REPLACE FUNCTION fn_customer_balance (
    p_customer IN VARCHAR2
) RETURN NUMBER AS
    v_total  NUMBER;
BEGIN
    SELECT NVL(SUM(a.balance), 0)
    INTO   v_total
    FROM   depositor d
    JOIN   account   a ON a.account_number = d.account_number
    WHERE  d.customer_name = p_customer;

    RETURN v_total;
END fn_customer_balance;
/
SHOW ERRORS
CREATE OR REPLACE FUNCTION fn_assets_band (
    p_branch IN VARCHAR2
) RETURN VARCHAR2 AS
    c_big_threshold CONSTANT NUMBER := 200000000;   -- GBP 200 M
    v_assets        branch.assets%TYPE;
BEGIN
    SELECT assets
    INTO   v_assets
    FROM   branch
    WHERE  branch_name = p_branch;

    IF v_assets >= c_big_threshold THEN
        RETURN 'Big';
    ELSE
        RETURN 'Small';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END fn_assets_band;
/
SHOW ERRORS

SELECT customer_name,
       fn_customer_balance(customer_name) AS total_balance
FROM   customer
WHERE  ROWNUM <= 5;


SELECT fn_customer_balance('T6 Test Customer') AS no_accounts_balance
FROM   dual;

SELECT branch_name,
       assets,
       fn_assets_band(branch_name) AS band
FROM   branch
ORDER  BY assets DESC;



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T8 - TRIGGER                                       (12 marks)
-- =====================================================================
--  PROBLEM
--    Every new loan must be recorded for audit, automatically, even
--    if the application forgets to do it.
--
--  WHAT TO WRITE
--    1. An audit table  loan_log  with:
--          log_id       NUMBER GENERATED BY DEFAULT AS IDENTITY
--                       PRIMARY KEY
--          loan_number  VARCHAR2(20)
--          amount       NUMBER(15,2)
--          inserted_by  VARCHAR2(30)
--          inserted_at  TIMESTAMP DEFAULT SYSTIMESTAMP
--    2. A trigger  trg_loan_insert  that fires AFTER INSERT ON loan,
--       FOR EACH ROW, and writes :NEW.loan_number and :NEW.amount
--       into loan_log, along with USER and SYSTIMESTAMP.
--
--  NOTE FOR DATABASE ACTIONS
--    After the trigger is created, add a test at the end:
--        INSERT INTO loan
--        VALUES ('L-TEST-01', 'London - City', 10000);
--        COMMIT;
--        SELECT * FROM loan_log WHERE loan_number = 'L-TEST-01';
--    The insert must use an existing branch_name (for example
--    'London - City') or the foreign key will reject it.
--
--  RUBRIC (12) - SELF-EVALUATION GUIDE
--    [ ] 2  Audit table structure correct
--    [ ] 3  Trigger fires on INSERT, FOR EACH ROW
--    [ ] 4  Trigger writes the correct :NEW values
--    [ ] 2  USER and SYSTIMESTAMP recorded
--    [ ] 1  Tested with an insert and a select
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T8 - TRIGGER =====');
END;
/

---- YOUR CODE STARTS HERE ----
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE loan_log PURGE';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE loan_log (
    log_id       NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    loan_number  VARCHAR2(20),
    amount       NUMBER(15,2),
    inserted_by  VARCHAR2(30),
    inserted_at  TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE OR REPLACE TRIGGER trg_loan_insert
AFTER INSERT ON loan
FOR EACH ROW
BEGIN
    INSERT INTO loan_log (loan_number, amount, inserted_by, inserted_at)
    VALUES (:NEW.loan_number, :NEW.amount, USER, SYSTIMESTAMP);
END trg_loan_insert;
/
SHOW ERRORS

INSERT INTO loan (loan_number, branch_name, amount)
SELECT 'L-T8-TEST', branch_name, 12345.67
FROM   branch
WHERE  ROWNUM = 1;
COMMIT;

SELECT log_id, loan_number, amount, inserted_by, inserted_at
FROM   loan_log;


DELETE FROM loan WHERE loan_number = 'L-T8-TEST';
COMMIT;



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  TASK T9 - INTEGRATION                                   (14 marks)
-- =====================================================================
--  PROBLEM
--    At the start of every month the bank credits 1% interest to
--    every account held at a 'Big' branch (assets >= 200,000,000).
--    Reuse fn_assets_band from Task T7 - do not re-write the logic.
--
--  WHAT TO WRITE
--    A procedure  sp_post_interest  that:
--      * loops over all accounts;
--      * checks the branch band using fn_assets_band;
--      * adds 1% of the balance (rounded to 2 dp) to each qualifying
--        account;
--      * prints the number of accounts credited and the total
--        interest paid;
--      * commits on success and rolls back on any error.
--
--  RUBRIC (14) - SELF-EVALUATION GUIDE
--    [ ] 2  Procedure compiles
--    [ ] 3  Uses fn_assets_band (not duplicated logic)
--    [ ] 4  Correct 1% arithmetic with ROUND(..., 2)
--    [ ] 3  COMMIT on success / ROLLBACK on failure
--    [ ] 2  Summary printed with count and total
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('===== T9 - INTEGRATION =====');
END;
/

---- YOUR CODE STARTS HERE ----
CREATE OR REPLACE PROCEDURE sp_post_interest AS
    c_rate      CONSTANT NUMBER := 0.01;   -- 1 %
    v_interest  NUMBER(15,2);
    v_count     PLS_INTEGER := 0;
    v_total     NUMBER(15,2) := 0;
BEGIN
    FOR r IN (SELECT account_number, branch_name, balance
              FROM   account)
    LOOP
        IF fn_assets_band(r.branch_name) = 'Big' THEN
            v_interest := ROUND(r.balance * c_rate, 2);

            UPDATE account
            SET    balance = balance + v_interest
            WHERE  account_number = r.account_number;

            v_count := v_count + 1;
            v_total := v_total + v_interest;
        END IF;
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Accounts credited : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('Total interest    : ' ||
                         TRIM(TO_CHAR(v_total, '999,999,990.00')));
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Interest run failed and was rolled back: ' || SQLERRM);
        RAISE;
END sp_post_interest;
/
SHOW ERRORS

SELECT a.account_number, a.branch_name, fn_assets_band(a.branch_name) AS band, a.balance
FROM   account a
WHERE  ROWNUM <= 5;

BEGIN
    sp_post_interest;
END;
/

SELECT a.account_number, a.branch_name, fn_assets_band(a.branch_name) AS band, a.balance
FROM   account a
WHERE  ROWNUM <= 5;



---- YOUR CODE ENDS HERE ----


-- =====================================================================
--  END OF PROJECT
--  Submit this file as T1_to_T9.sql, together with:
--    * output.txt   - full Script Output tab content from this run
--    * README.md    - one short paragraph per task
--  Both the SQL file and the output are required.
-- =====================================================================

BEGIN
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('==================================================');
  DBMS_OUTPUT.PUT_LINE('  All tasks executed.');
  DBMS_OUTPUT.PUT_LINE('  Capture the Script Output tab as output.txt.');
  DBMS_OUTPUT.PUT_LINE('==================================================');
END;
/