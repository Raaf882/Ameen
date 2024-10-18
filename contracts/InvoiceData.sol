// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

contract InvoiceData {
    
    struct Employee {
        uint256 empNumber;
        string name;
        string accountingInfo;
        uint256 timestamp;
    }

    mapping(uint256 => Employee) public empData;

    function addEmployee(
        uint256 _empNumber,
        string memory _name,
        string memory _accountingInfo,
        uint256 _timestamp
    ) public returns (uint256) {
        // Check if the employee with this number already exists
        require(empData[_empNumber].empNumber == 0, "Employee already exists");

        // Add new employee data to the mapping
        empData[_empNumber] = Employee(
            _empNumber,
            _name,
            _accountingInfo,
            _timestamp
        );

        return _empNumber;
    }

    function getEmployeeInfo(uint256 _empNumber)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            uint256
        )
    {
        Employee memory employee = empData[_empNumber];
        return (
            employee.empNumber,
            employee.name,
            employee.accountingInfo,
            employee.timestamp
        );
    }

    struct CompanyInfo {
        string companyName;
        string taxNumber;
        string postalCode;
        string ownerId;
    }

    struct ClientInfo {
        string clientName;
        string clientId;
        string postalCode;
        string taxNumber;
    }

    struct Product {
        string name;
        uint256 priceBeforeTax;
        uint256 tax;
        uint256 priceAfterTax;
    }

    enum InvoiceType { Cash, Credit, Both }

    struct Invoice {
        uint256 date;
        InvoiceType invoiceType;
        uint256 amountPaid;
        Product[] products;
        uint256 totalBeforeTax;
        uint256 totalTax;
        uint256 totalWithTax;
        string taxInvoiceCode;
    }

    mapping(uint256 => CompanyInfo) private companies;
    mapping(uint256 => ClientInfo) private clients;
    mapping(uint256 => Invoice) public invoices;
    uint256 public invoiceCount = 0;


    function saveCompany(
        uint256 _companyId,
        string memory _companyName,
        string memory _taxNumber,
        string memory _postalCode,
        string memory _ownerId
    ) public {
        companies[_companyId] = CompanyInfo(
            _companyName,
            _taxNumber,
            _postalCode,
            _ownerId
        );
    }

    function saveClient(
        uint256 _clientId,
        string memory _clientName,
        string memory _taxNumber,
        string memory _postalCode,
        string memory _clientIdString
    ) public {
        clients[_clientId] = ClientInfo(
            _clientName,
            _taxNumber,
            _postalCode,
            _clientIdString
        );
    }

    function createInvoice(
    uint256 _date,
    InvoiceType _invoiceType,
    uint256 _amountPaid,
    string[] memory _productNames,
    uint256[] memory _pricesBeforeTax,
    uint256[] memory _taxes,
    uint256[] memory _pricesAfterTax,
    uint256 _totalBeforeTax,
    uint256 _totalTax,
    uint256 _totalWithTax,
    string memory _taxInvoiceCode
) public {
    require(
        _productNames.length == _pricesBeforeTax.length &&
        _pricesBeforeTax.length == _taxes.length &&
        _taxes.length == _pricesAfterTax.length,
        "Product arrays must be of equal length"
    );

    // Initialize the invoice directly
    Invoice storage newInvoice = invoices[invoiceCount];
    newInvoice.date = _date;
    newInvoice.invoiceType = _invoiceType;
    newInvoice.amountPaid = _amountPaid;
    newInvoice.totalBeforeTax = _totalBeforeTax;
    newInvoice.totalTax = _totalTax;
    newInvoice.totalWithTax = _totalWithTax;
    newInvoice.taxInvoiceCode = _taxInvoiceCode;

    // Add products separately
    addProductsToInvoice(newInvoice, _productNames, _pricesBeforeTax, _taxes, _pricesAfterTax);

    invoiceCount++;
}

function addProductsToInvoice(
    Invoice storage invoice,
    string[] memory _productNames,
    uint256[] memory _pricesBeforeTax,
    uint256[] memory _taxes,
    uint256[] memory _pricesAfterTax
) internal {
    for (uint256 i = 0; i < _productNames.length; i++) {
        invoice.products.push(
            Product(
                _productNames[i],
                _pricesBeforeTax[i],
                _taxes[i],
                _pricesAfterTax[i]
            )
        );
    }
}


}
