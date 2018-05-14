FROM zhunting/ruby-2.4-centos

COPY database.yml /tmp

COPY run_test.sh /

CMD /run_test.sh
