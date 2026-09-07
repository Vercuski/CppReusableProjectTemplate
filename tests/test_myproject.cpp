#include <gtest/gtest.h>

#include "myproject/myproject.hpp"

namespace {

TEST(Greeter, DefaultSalutationIsHello) {
    const myproject::Greeter greeter;
    EXPECT_EQ(greeter.salutation(), "Hello");
}

TEST(Greeter, GreetsByName) {
    const myproject::Greeter greeter;
    EXPECT_EQ(greeter.greet("World"), "Hello, World!");
}

TEST(Greeter, HonorsCustomSalutation) {
    const myproject::Greeter greeter{"Hey"};
    EXPECT_EQ(greeter.greet("Scott"), "Hey, Scott!");
}

TEST(Clamp, ReturnsValueWithinRange) {
    EXPECT_EQ(myproject::clamp(5, 0, 10), 5);
}

TEST(Clamp, ClampsBelowLowerBound) {
    EXPECT_EQ(myproject::clamp(-5, 0, 10), 0);
}

TEST(Clamp, ClampsAboveUpperBound) {
    EXPECT_EQ(myproject::clamp(15, 0, 10), 10);
}

TEST(Version, StringIsNonEmpty) {
    EXPECT_GT(std::string_view{myproject::VERSION_STRING}.size(), 0U);
}

}  // namespace
