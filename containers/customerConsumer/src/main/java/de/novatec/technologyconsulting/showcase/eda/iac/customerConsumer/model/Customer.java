package de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.model;


public class Customer {
    public int getId() {
        return Id;
    }

    public void setId(int id) {
        Id = id;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.model.Address getAddress() {
        return Address;
    }

    public void setAddress(de.novatec.technologyconsulting.showcase.eda.iac.customerConsumer.model.Address address) {
        Address = address;
    }

    private int Id;
    private String Name;
    private Address Address;


}
