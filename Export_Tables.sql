SELECT 'bcp ' + st.NAME + ' out c:\Target\' + st.NAME + '.csv -T -c -d ' + DB_NAME()
FROM sys.tables st