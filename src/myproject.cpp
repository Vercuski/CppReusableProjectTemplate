#include "myproject/myproject.hpp"

namespace myproject {

Greeter::Greeter(std::string_view salutation) : salutation_(salutation) {}

std::string Greeter::greet(std::string_view name) const {
    std::string result;
    result.reserve(salutation_.size() + name.size() + 3);
    result += salutation_;
    result += ", ";
    result += name;
    result += '!';
    return result;
}

}  // namespace myproject
