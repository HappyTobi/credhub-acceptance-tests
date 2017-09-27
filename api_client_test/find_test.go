package acceptance_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	"github.com/cloudfoundry-incubator/credhub-cli/credhub/credentials"
	"github.com/cloudfoundry-incubator/credhub-cli/credhub/credentials/generate"
	"time"
	"fmt"
	"strconv"
)

var _ = Describe("Find", func() {
	currentTime := time.Now().UnixNano()

	passwordName1 := testCredentialPath(fmt.Sprint("find-test/first-password-", currentTime))
	passwordName2 := testCredentialPath(fmt.Sprint("find-test/second-password-", currentTime))

	var expectedPassword1 credentials.Password
	var expectedPassword2 credentials.Password

	BeforeEach(func() {
		var err error

		generatePassword := generate.Password{Length: 10}

		expectedPassword1, err = credhubClient.GeneratePassword(passwordName1, generatePassword, true)
		Expect(err).ToNot(HaveOccurred())

		expectedPassword2, err = credhubClient.GeneratePassword(passwordName2, generatePassword, true)
		Expect(err).ToNot(HaveOccurred())
	})

	AfterEach(func() {
		err := credhubClient.Delete(passwordName1)
		Expect(err).ToNot(HaveOccurred())
		err = credhubClient.Delete(passwordName2)
		Expect(err).ToNot(HaveOccurred())
	})

	Specify("finding the credentials by path", func() {
		results, err := credhubClient.FindByPath(testCredentialPrefix() + "find-test")

		Expect(err).ToNot(HaveOccurred())

		findResult1 := credentials.FindByNameResult{Name: passwordName1, VersionCreatedAt: expectedPassword1.VersionCreatedAt}
		findResult2 := credentials.FindByNameResult{Name: passwordName2, VersionCreatedAt: expectedPassword2.VersionCreatedAt}
		Expect(results.Credentials).To(ConsistOf(findResult1, findResult2))
	})

	Specify("finding the credentials by name-like", func() {
		results, err := credhubClient.FindByPartialName(strconv.FormatInt(currentTime, 10))

		Expect(err).ToNot(HaveOccurred())

		findResult1 := credentials.FindByNameResult{Name: passwordName1, VersionCreatedAt: expectedPassword1.VersionCreatedAt}
		findResult2 := credentials.FindByNameResult{Name: passwordName2, VersionCreatedAt: expectedPassword2.VersionCreatedAt}
		Expect(results.Credentials).To(ConsistOf(findResult1, findResult2))
	})
})
