package de.novatec.customerconsumer.controller;

import de.novatec.customerconsumer.repository.CustomerRepository;
import de.novatec.customerconsumer.model.Customer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;

@RestController
public class CustomerController {
  private final CustomerRepository customers;

  public CustomerController(CustomerRepository customers) {
    this.customers = customers;
  }

  @GetMapping("/customers")
  public Collection<Customer> getCustomer() {
    return customers.get();
  }
}
