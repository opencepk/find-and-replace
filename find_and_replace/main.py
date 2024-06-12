import unittest
import tempfile
import os
from unittest.mock import patch, mock_open
import json
from main import replace_in_file, main

class TestReplaceInFile(unittest.TestCase):
    def setUp(self):
        self.temp_file = tempfile.NamedTemporaryFile(delete=False)
        self.temp_file.write(b'Test line 1\nTest line 2\nTest line 3\n')
        self.temp_file.close()

    def tearDown(self):
        os.unlink(self.temp_file.name)

    def test_replace_in_file(self):
        replace_in_file(self.temp_file.name, 'Test', 'Replaced')
        with open(self.temp_file.name, 'r') as f:
            lines = f.readlines()
        self.assertEqual(lines, ['Replaced line 1\n', 'Replaced line 2\n', 'Replaced line 3\n'])

class TestMain(unittest.TestCase):
    @patch('argparse.ArgumentParser.parse_args')
    @patch('builtins.open', new_callable=mock_open, read_data='[{"search": "Test", "replacement": "Replaced"}]')
    def test_main_with_file_mode(self, mock_file, mock_args):
        mock_args.return_value = argparse.Namespace(files=[os.path.join(os.getcwd(), 'test.txt')], find=None, replacement=None, read_from_file=True, config='config.json')
        with open('test.txt', 'w') as f:
            f.write('Test line 1\nTest line 2\nTest line 3\n')
        main()
        with open('test.txt', 'r') as f:
            lines = f.readlines()
        self.assertEqual(lines, ['Replaced line 1\n', 'Replaced line 2\n', 'Replaced line 3\n'])
        os.remove('test.txt')

    @patch('argparse.ArgumentParser.parse_args')
    def test_main_with_direct_mode(self, mock_args):
        mock_args.return_value = argparse.Namespace(files=[os.path.join(os.getcwd(), 'test.txt')], find='Test', replacement='Replaced', read_from_file=False, config=None)
        with open('test.txt', 'w') as f:
            f.write('Test line 1\nTest line 2\nTest line 3\n')
        main()
        with open('test.txt', 'r') as f:
            lines = f.readlines()
        self.assertEqual(lines, ['Replaced line 1\n', 'Replaced line 2\n', 'Replaced line 3\n'])
        os.remove('test.txt')

if __name__ == '__main__':
    unittest.main()