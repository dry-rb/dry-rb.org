describe("Example", function() {
  var date;

  beforeEach(function() {
    date = new Date();
  });

  it("should have a year after 1999", function() {
    var year = date.getUTCFullYear();
    expect(year).toBeGreaterThan(1999);
  });
});
