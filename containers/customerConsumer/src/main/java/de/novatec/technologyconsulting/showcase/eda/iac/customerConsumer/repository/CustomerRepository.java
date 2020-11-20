package de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.repository;

import de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.model.Customer;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

@Repository
public class CustomerRepository {
    private Map<Integer, Customer> customers = new HashMap<>();

    public Collection<Customer> get() {
        return customers.values();
    }

    public void update(Customer customer) {
        Customer customerToBeUpdated = customers.get(customer.getId());
        customerToBeUpdated = customer;
        customers.put(customer.getId(), customer);
    }
}
