TESTING.md 
# 🧪 Testing Documentation

This file keeps track of key tests across the project. Update this file as your test coverage improves.

---

## 🏃‍♂️ Core User Flows (Feature Specs)
- [x] User signs up successfully
- [x] User signs in (via other tests)
- [x] User signs out
- [x] User resets password
- [x] User confirms email address
- [ ] User edits profile
- [x] Role based Sign In

---

## 📄 Page Smoke Tests (System Specs)
- [ ] Every main model page loads

---

## 🛠️ CRUD Operations (Feature + System Specs)
- [ ] Create Equipment
- [ ] Read (View) Equipment
- [ ] Update Equipment
- [ ] Delete Equipment

---

## 🔒 Security & Access Control
- [ ] Non-logged-in users are redirected to login
- [ ] Non-admin users cannot access admin pages
- [ ] Deactivated users cannot log in
- [ ] Confirmed email required for login

---

## 🎯 Flash Messages (UI Feedback)
- [x] Flash shows on successful login
- [x] Flash shows on logout
- [ ] Flash shows on password reset
- [ ] Flash shows on unauthorized access
- [ ] Flash shows on profile update

---

## 📦 Model Tests
- [ ] User validations (email, password, etc.)
- [ ] Equipment validations
- [ ] Associations (User has_many Equipment, etc.)

---

## 🔌 Request Specs
- [ ] API returns 200 OK for authenticated user
- [ ] API returns 401 Unauthorized for guest
- [ ] Equipment API create/update/delete tests

---

## 🧹 Other Useful Tests
- [ ] Background jobs (if any) are enqueued properly
- [ ] Email confirmation is sent after signup
- [ ] Password reset email is sent
- [ ] File uploads succeed

---

# 📈 How To Run Tests Locally

```bash
bundle exec rspec
