package de.novatec.customerconsumer.controller;

import de.novatec.customerconsumer.repository.CustomerRepository;
import de.novatec.customerconsumer.model.Customer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collection;

@RestController
public class CustomerController {
  private final CustomerRepository customerRepository;

  public CustomerController(CustomerRepository customerRepository) {
    this.customerRepository = customerRepository;
  }

  @GetMapping("customers")
  public Collection<Customer> getCustomers() {
    return customerRepository.getAll();
  }

  @GetMapping("customers/{customerId}")
  public Customer getCustomer(@PathVariable String customerId) throws NotFoundExeption {
    return customerRepository.getById(Integer.parseInt(customerId));
  }
}
