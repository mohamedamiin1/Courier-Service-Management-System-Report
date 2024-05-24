-- Create sequence for generating unique IDs
CREATE SEQUENCE parcel_seq START WITH 1 INCREMENT BY 1;

-- Create tables for parcel, customer, and delivery
CREATE TABLE parcels (
    parcel_id NUMBER PRIMARY KEY,
    sender VARCHAR2(100),
    receiver VARCHAR2(100),
    delivery_address VARCHAR2(255),
    delivery_date DATE,
    status VARCHAR2(50)
);
select  * from parcels;
SELECT parcel_id, sender, receiver, delivery_address, delivery_date
FROM parcels
WHERE status = 'Scheduled';

 CREATE TABLE customers (
   customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    address VARCHAR2(255),
    contact_information VARCHAR2(100)
);
select *from customers;
CREATE SEQUENCE customer_id_seq;


CREATE TABLE deliveries (
    delivery_id NUMBER PRIMARY KEY,
    parcel_id NUMBER,
    delivery_date DATE,
    CONSTRAINT fk_parcel FOREIGN KEY (parcel_id) REFERENCES parcels(parcel_id)
);
select *from deliveries;
-- Create a view to display all parcels
CREATE OR REPLACE VIEW all_parcels AS
SELECT * FROM parcels;

-- Create a view to display all customers
CREATE OR REPLACE VIEW all_customers AS
SELECT * FROM customers;

-- Create a view to display all deliveries
CREATE OR REPLACE VIEW all_deliveries AS
SELECT * FROM deliveries;

-- Create a procedure to schedule a delivery
CREATE OR REPLACE PROCEDURE schedule_delivery(
    p_sender IN VARCHAR2,
    p_receiver IN VARCHAR2,
    p_delivery_address IN VARCHAR2,
    p_delivery_date IN DATE
) AS
    v_parcel_id NUMBER;
BEGIN
    -- Generate unique parcel ID
    SELECT parcel_seq.NEXTVAL INTO v_parcel_id FROM dual;
    
    -- Insert parcel details into parcels table
    INSERT INTO parcels (parcel_id, sender, receiver, delivery_address, delivery_date, status)
    VALUES (v_parcel_id, p_sender, p_receiver, p_delivery_address, p_delivery_date, 'Scheduled');
    
    -- Insert delivery details into deliveries table
    INSERT INTO deliveries (delivery_id, parcel_id, delivery_date)
    VALUES (v_parcel_id, v_parcel_id, p_delivery_date);
    
    COMMIT;
END schedule_delivery;
/

-- Create a trigger to update parcel status when a delivery is scheduled
CREATE OR REPLACE TRIGGER update_parcel_status
AFTER INSERT ON deliveries
FOR EACH ROW
BEGIN
    UPDATE parcels
    SET status = 'Scheduled'
    WHERE parcel_id = :NEW.parcel_id;
END;
/

-- Example usage of the procedure to schedule a delivery
BEGIN
    schedule_delivery('John Doe', 'Jane Smith', '123 Main St', SYSDATE + 3);
END;
/

CREATE SEQUENCE parcel_id_seq
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1;

select *from Scheduled;



-- Create table for branch details
CREATE TABLE branch (
    Branch_id NUMBER PRIMARY KEY,
    Street_building VARCHAR2(100),
    City VARCHAR2(50)PRIMARY KEY,
    State VARCHAR2(50),
    Zip_code VARCHAR2(20),
    Country VARCHAR2(50),
    Contact_number VARCHAR2(20)
);

-- Create sequence for branch_id
CREATE SEQUENCE branch_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Trigger to automatically populate branch_id
CREATE OR REPLACE TRIGGER branch_id_trigger
BEFORE INSERT ON branch
FOR EACH ROW
BEGIN
    SELECT branch_seq.NEXTVAL INTO :new.Branch_id FROM dual;
END;
/

-- Procedure to add a new branch
CREATE OR REPLACE PROCEDURE add_new_branch (
    p_street_building IN VARCHAR2,
    p_city IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zip_code IN VARCHAR2,
    p_country IN VARCHAR2,
    p_contact_number IN VARCHAR2
)
IS
BEGIN
    INSERT INTO branch (Street_building, City, State, Zip_code, Country, Contact_number)
    VALUES (p_street_building, p_city, p_state, p_zip_code, p_country, p_contact_number);
    COMMIT;
END add_new_branch;
/

-- View to list existing branches
CREATE OR REPLACE VIEW branch_list_view AS
SELECT Branch_id, Street_building, City || '/' || State || '/' || Zip_code AS City_State_Zip, Country, Contact_number
FROM branch;
select * from branch;


-- Create Tables
CREATE TABLE branch (
    branch_id NUMBER PRIMARY KEY,
    branch_city VARCHAR2(100) NOT NULL
);

CREATE TABLE branch_staff (
    staff_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    branch_id NUMBER,
    city VARCHAR2(50), -- Added column for city
    email VARCHAR2(100) UNIQUE,
    password VARCHAR2(100),
    CONSTRAINT fk_branch_staff_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- Create Sequence
CREATE SEQUENCE branch_staff_seq START WITH 1 INCREMENT BY 1;

-- Create Trigger
CREATE OR REPLACE TRIGGER branch_staff_trigger
BEFORE INSERT ON branch_staff
FOR EACH ROW
BEGIN
    SELECT branch_staff_seq.NEXTVAL INTO :NEW.staff_id FROM dual;
END;

-- Create Procedure to Add Branch Staff
CREATE OR REPLACE PROCEDURE add_branch_staff(
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_branch_id IN NUMBER,
    p_city IN VARCHAR2,
    p_email IN VARCHAR2,
    p_password IN VARCHAR2
)
AS
BEGIN
    INSERT INTO branch_staff (staff_id, first_name, last_name, branch_id, city, email, password)
    VALUES (branch_staff_seq.NEXTVAL, p_first_name, p_last_name, p_branch_id, p_city, p_email, p_password);
    COMMIT;
END;

-- Create View for Branch Staff List
CREATE OR REPLACE VIEW branch_staff_list AS
SELECT bs.staff_id, bs.first_name || ' ' || bs.last_name AS staff_name, bs.email, bs.city
FROM branch_staff bs
JOIN branch b ON bs.branch_id = b.branch_id;
select * from BRANCH_STAFF;



CREATE TABLE sender (
    sender_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    address VARCHAR2(255),
    contact VARCHAR2(50)
);

CREATE TABLE recipient (
    recipient_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    address VARCHAR2(255),
    contact VARCHAR2(50)
);

CREATE TABLE parcel (
    parcel_id NUMBER PRIMARY KEY,
    sender_id NUMBER,
    recipient_id NUMBER,
    weight NUMBER,
    height NUMBER,
    length NUMBER,
    width NUMBER,
    price NUMBER,
    type VARCHAR2(20),  -- 'Deliver' or 'Pickup'
    branch_processed VARCHAR2(100),
    pickup_branch VARCHAR2(100),  -- NULL if type is 'Deliver'
    CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES sender(sender_id),
    CONSTRAINT fk_recipient FOREIGN KEY (recipient_id) REFERENCES recipient(recipient_id)
);


CREATE SEQUENCE sender_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE recipient_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE parcel_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE add_sender (
    p_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_contact IN VARCHAR2,
    p_sender_id OUT NUMBER
) AS
BEGIN
    SELECT sender_seq.NEXTVAL INTO p_sender_id FROM dual;
    INSERT INTO sender (sender_id, name, address, contact)
    VALUES (p_sender_id, p_name, p_address, p_contact);
END;

CREATE OR REPLACE PROCEDURE add_recipient (
    p_name IN VARCHAR2,
    p_address IN VARCHAR2,
    p_contact IN VARCHAR2,
    p_recipient_id OUT NUMBER
) AS
BEGIN
    SELECT recipient_seq.NEXTVAL INTO p_recipient_id FROM dual;
    INSERT INTO recipient (recipient_id, name, address, contact)
    VALUES (p_recipient_id, p_name, p_address, p_contact);
END;


CREATE OR REPLACE PROCEDURE add_parcel (
    p_sender_id IN NUMBER,
    p_recipient_id IN NUMBER,
    p_weight IN NUMBER,
    p_height IN NUMBER,
    p_length IN NUMBER,
    p_width IN NUMBER,
    p_price IN NUMBER,
    p_type IN VARCHAR2,
    p_branch_processed IN VARCHAR2,
    p_pickup_branch IN VARCHAR2,
    p_parcel_id OUT NUMBER
) AS
BEGIN
    SELECT parcel_seq.NEXTVAL INTO p_parcel_id FROM dual;
    INSERT INTO parcel (
        parcel_id, sender_id, recipient_id, weight, height, length, width, price,
        type, branch_processed, pickup_branch
    ) VALUES (
        p_parcel_id, p_sender_id, p_recipient_id, p_weight, p_height, p_length,
        p_width, p_price, p_type, p_branch_processed, p_pickup_branch
    );
END;


CREATE OR REPLACE TRIGGER before_insert_parcel
BEFORE INSERT ON parcel
FOR EACH ROW
BEGIN
    IF :NEW.type = 'Deliver' THEN
        :NEW.pickup_branch := NULL;
    END IF;
END;


-- View all tables
SELECT table_name FROM user_tables;

-- View all sequences
SELECT sequence_name FROM user_sequences;

-- View all procedures
SELECT object_name FROM user_procedures WHERE object_type = 'PROCEDURE';

-- View all triggers
SELECT trigger_name FROM user_triggers;


DECLARE
    sender_id NUMBER;
    recipient_id NUMBER;
    parcel_id NUMBER;
BEGIN
    -- Add sender
    add_sender('John Doe', '123 Sender St', '123-456-7890', sender_id);
    
    -- Add recipient
    add_recipient('Jane Smith', '456 Recipient Ave', '098-765-4321', recipient_id);
    
    -- Add parcel
    add_parcel(sender_id, recipient_id, 2.5, 10, 20, 15, 50, 'Deliver', 'New York', NULL, parcel_id);
    
    DBMS_OUTPUT.PUT_LINE('New parcel ID: ' || parcel_id);
END;


CREATE TABLE users (
    user_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    password_hash VARCHAR2(100) NOT NULL
);


CREATE OR REPLACE PROCEDURE user_signup(
    p_username IN VARCHAR2,
    p_email IN VARCHAR2,
    p_password IN VARCHAR2
)
IS
BEGIN
    INSERT INTO users (username, email, password_hash)
    VALUES (p_username, p_email, p_password);
    COMMIT;
END user_signup;


CREATE OR REPLACE FUNCTION user_login(
    p_username IN VARCHAR2,
    p_password IN VARCHAR2
)
RETURN BOOLEAN
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE username = p_username AND password_hash = p_password;
    
    IF v_count = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END user_login;

