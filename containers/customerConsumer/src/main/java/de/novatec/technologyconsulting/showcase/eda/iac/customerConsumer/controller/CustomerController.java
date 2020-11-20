package de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.controller;

import de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.model.Customer;
import de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;
import java.util.Random;

@RestController
public class CustomerController {

    @Autowired
    private CustomerRepository customers;

    @GetMapping("/customers")
    public Collection<Customer> getCustomer() {
        return customers.get();
    }
}
