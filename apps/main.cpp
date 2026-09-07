#include <cstdlib>
#include <iostream>
#include <string_view>

#include "myproject/myproject.hpp"
#include "myproject/version.hpp"

int main(int argc, char** argv) {
    const std::string_view name = (argc > 1) ? std::string_view{argv[1]} : std::string_view{"World"};

    const myproject::Greeter greeter;
    std::cout << greeter.greet(name) << '\n';
    std::cout << "myproject version " << myproject::VERSION_STRING << '\n';

    return EXIT_SUCCESS;
}
